{lib, ...}: let
  # a function that gets an igloo modules config
  moduleCfg = config: name: let
    namePath = lib.splitString "." name;
  in
    lib.getAttrFromPath namePath config.igloo.modules;

  # a function that conditionally compiles a module if the target matches the `iglooTarget`
  wrapTargetModule = target: content: args @ {iglooTarget, ...}: let
    # if the target is a list, check if the iglooTarget is contained within it
    targetContains = lib.isList target && builtins.elem iglooTarget target;

    # if the target is anything else, just directly compare it to the iglooTarget
    targetMatches = target == iglooTarget;

    targetGlobal = target == "global";

    # the target is deemed valid if it satisfies any of the match parameters
    targetValid = targetContains || targetMatches || targetGlobal;
  in
    if targetValid
    then
      # if the content is a function, call it using the arguments
      if lib.isFunction content
      then content args
      else content
    else {};

  module = {
    name, # the name of the igloo module
    enabled ? false, # should this module be enabled by default on all targets
    igloo ? {}, # igloo configuration to apply to all targets (when enabled)
    imports ? [], # additional imports to apply to all targets
    overlays ? [], # overlays to apply to nixpkgs on all targets
    packages ? [], # packages to include on all targets (when enabled)
    global ? {}, # configuration to apply to all targets
    nixos ? {}, # configuration to apply to only nixos targets
    home ? {}, # configuration to apply to only home targets
  }: let
    # generate the default options for this module
    moduleOptions = {
      # create a default enable option for every module
      igloo.modules."${name}".enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enables the '${name}' igloo module.";
        default = enabled;
      };
    };

    # wraps and generates a module for a specific igloo target
    iglooTargetModule = target: content: args: let
      # ensure the content is imported if its a path
      importedContent =
        if lib.isPath content
        then import content
        else content;

      # create the iglooCtx with useful shortcuts
      iglooCtx = rec {
        # define simple keys to provide quick acess to modules
        modules = args.config.igloo.modules;
        module = modules."${name}";

        # define useful functions for querying modules
        # a function that returns true if the module `name` exists and is enabled
        modEnabled = name: (lib.attrByPath ["${name}" "enable"] false modules);

        # define keys to provide quick access to user information
        # NOTE: On home targets, the users will always be empty and is basically useless
        users = rec {
          # returns the names of all users defined in the system
          all = lib.attrNames (lib.attrByPath ["home-manager" "users"] {} args.config);
          # returns the names of all users with the current module enabled on the system
          enabled = lib.filter (userName: lib.attrByPath ["home-manager" "users" "${userName}" "igloo" "modules" "${name}" "enable"] false args.config) all;
          # returns the names of all users with the current module disabled on the system
          disabled = lib.subtractLists all enabled;
          # returns true if any user has the current module enabled
          anyEnabled = builtins.length enabled > 0;

          # returns all igloo modules configuration for the specified `user`
          modules = user: args.config.home-manager.users."${user}".igloo.modules;
          # returns the current igloo modules configuration for the specified `user`
          module = user: (modules user)."${name}";

          # simple functions for generating user attribute sets
          genAll = lib.genAttrs all;
          genEnabled = lib.genAttrs enabled;
          genDisabled = lib.genAttrs disabled;
        };
      };

      # if the imported content is a function, resolve it with the args
      resolvedContent =
        if lib.isFunction importedContent
        then importedContent (args // {inherit iglooCtx;}) # include the iglooCtx when resolving the module
        else importedContent;

      # ensure the content is an attribute set
      attrContent =
        if lib.isAttrs resolvedContent
        then resolvedContent
        else throw "Expected igloo target module '${name}':'${target}' to evaluate to an attribute set. Found '${lib.typeOf resolvedContent}'";

      # validate that the content has the correct top level keys
      listStr = list: "'${lib.concatStringsSep "', '" list}'";
      validKeys = ["imports" "options" "enabled" "disabled" "always"];
      badAttrs = removeAttrs attrContent validKeys;
      validContent =
        if badAttrs != {}
        then throw "Igloo target module '${name}':'${target}' contains invalid top level keys (${listStr (lib.attrNames badAttrs)}). Valid keys are (${listStr validKeys})"
        else {
          # directly pass through the imports
          imports = attrContent.imports or [];
          # wrap the options under the correct igloo module path
          options.igloo.modules."${name}" = attrContent.options or {};
          # merge the configurations to match their specified enable types
          config = lib.mkMerge [
            (attrContent.always or {})
            (lib.mkIf iglooCtx.module.enable (attrContent.enabled or {}))
            (lib.mkIf (!iglooCtx.module.enable) (attrContent.disabled or {}))
          ];
        };
    in
      wrapTargetModule target validContent args;

    # generate module imports for each target
    moduleImports = [
      # apply the extra igloo config to all systems only when the module is enabled
      (iglooTargetModule "global" {enabled.igloo = igloo;})

      # apply the packages to the correct config location for each system when the module is enabled
      (iglooTargetModule "nixos" {
        always.nixpkgs.overlays = overlays;
        enabled.environment.systemPackages = packages;
      })
      (iglooTargetModule "home" {
        always.nixpkgs.overlays = overlays;
        enabled.home.packages = packages;
      })

      # apply target specific modules to their respective targets
      (iglooTargetModule "global" global)
      (iglooTargetModule "nixos" nixos)
      (iglooTargetModule "home" home)
    ];
  in {
    # every system will get an module enable option by default
    options = moduleOptions;

    # combine the user and module imports and expose them unconditionally to every system
    imports = imports ++ moduleImports;
  };
in {
  inherit module moduleCfg;
}
