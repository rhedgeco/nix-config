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
    imports ? [], # additional imports to apply to all targets (even if not enabled)
    options ? {}, # additional igloo module options to define on all targets (even if not enabled)
    packages ? [], # packages to include on all targets (when enabled)
    nixos ? {}, # configuration to apply to only nixos targets (when enabled)
    home ? {}, # configuration to apply to only home targets (when enabled)
  }: let
    # combine all options into a single set
    moduleOptions = {
      # nest the options under the correct igloo module route
      igloo.modules."${name}" = (
        {
          # add an enable option to the module by default
          enable = lib.mkOption {
            type = lib.types.bool;
            description = "Enables the '${name}' igloo module.";
            default = enabled;
          };
        }
        # and merge the user defined options second to the enable can be overriden
        // options
      );
    };

    # a function that wraps and generates a module for a specific igloo target
    iglooTargetModule = target: content: args: let
      # ensure the content is imported if its a path
      importedContent =
        if lib.isPath content
        then import content
        else content;

      # generate extra args to be used when resolving the content
      extraArgs = let
        # extract module and modules path from the config
        iglooModules = args.config.igloo.modules;
        iglooModule = iglooModules."${name}";

        # extract user information that can be useful to the module author
        userEnabled = userName: lib.attrByPath ["igloo" "modules" "${name}" "enable"] false args.config.home-manager.users."${userName}";
        enabledUsers = lib.filter userEnabled (lib.attrNames args.config.home-manager.users or {});
        iglooUsers = {
          anyEnabled = builtins.length enabledUsers > 0;
          enabled = enabledUsers;
        };
      in {
        inherit iglooModule iglooModules iglooUsers;
      };

      # if the imported content is a function, resolve it with the args
      resolvedContent =
        if lib.isFunction importedContent
        then importedContent (args // extraArgs)
        else importedContent;

      # ensure the content is an attribute set
      attrContent =
        if lib.isAttrs resolvedContent
        then resolvedContent
        else throw "Expected igloo target module '${name}':'${target}' to evaluate to an attribute set. Found '${lib.typeOf resolvedContent}'";

      # validate that the content has the correct top level keys
      listStr = list: "'${lib.concatStringsSep "', '" list}'";
      validKeys = ["imports" "options" "enabled" "disabled" "always" "userEnabled"];
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
            (lib.mkIf extraArgs.iglooModule.enable (attrContent.enabled or {}))
            (lib.mkIf (!extraArgs.iglooModule.enable) (attrContent.disabled or {}))
          ];
        };
    in
      wrapTargetModule target validContent args;

    # combine all module imports into a single list
    moduleImports =
      # include the user defined imports as well
      imports
      ++ [
        # apply the extra igloo config to all systems only when the module is enabled
        (iglooTargetModule "global" {enabled.igloo = igloo;})

        # apply the packages to the correct config location for each system when the module is enabled
        (iglooTargetModule "nixos" {
          enabled.environment.systemPackages = packages;
        })
        (iglooTargetModule "home" {
          enabled.home.packages = packages;
        })

        # apply target specific modules to their respective targets
        (iglooTargetModule "nixos" nixos)
        (iglooTargetModule "home" home)
      ];
  in {
    # expose the module options unconditionally to every system
    options = moduleOptions;

    # combine the user and module imports and expose them unconditionally to every system
    imports = moduleImports;
  };
in {
  inherit module moduleCfg;
}
