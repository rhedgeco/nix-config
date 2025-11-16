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
    config ? {}, # additional configuration to apply to all targets (when enabled)
    packages ? [], # packages to include on all targets (when enabled)
    nixos ? {}, # configuration to apply to only nixos targets (when enabled)
    home ? {}, # configuration to apply to only home targets (when enabled)
  }: let
    # generate the enable option for this module
    enableOption = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enables the '${name}' igloo module.";
        default = enabled;
      };
    };

    # combine all options into a single set
    moduleOptions = {
      # nest the options under the correct igloo module route
      # and merge the user defined options second to the enable can be overriden
      igloo.modules."${name}" = enableOption // options;
    };

    # generate a module that copies all system level configuration into home manager
    homePassthroughModule = args: let
      linkOptions = systemCfg: optionSet:
        lib.mapAttrs (optionName: optionValue: let
          # extract the value set in the system config
          systemValue = systemCfg.${optionName};
        in
          # if the value is of '_type' == 'option', then it is an leaf option value
          if (optionValue ? "_type" && optionValue._type == "option")
          # if the value is an leaf option, replace it with the system value as a default
          then lib.mkDefault systemValue
          # if its not a leaf, then its a parent and we need to link the nested options
          else linkOptions systemValue optionValue)
        optionSet;
    in {
      # pass all the linked system config into home manager as a shared module
      config.home-manager.sharedModules = [(linkOptions args.config moduleOptions)];
    };

    # a function that wraps and generates a module for a specific igloo target
    iglooTargetModule = target: content: args: let
      # ensure the content is imported if its a path
      importedContent =
        if lib.isPath content
        then import content
        else content;

      # generate extra args to be used when resolving the content
      extraArgs = {
        module = args.config.igloo.modules."${name}";
        modules = args.config.igloo.modules;
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
      badAttrs = removeAttrs attrContent ["imports" "options" "config"];
      validContent =
        if badAttrs != {}
        then throw "Igloo target module '${name}':'${target}' contains invalid top level keys ('${lib.concatStringsSep "', '" (lib.attrNames badAttrs)}'). Igloo targets must use longform representation."
        else {
          imports = attrContent.imports or [];
          # wrap the options in the
          options.igloo.modules."${name}" = attrContent.options or {};
          config = lib.mkIf extraArgs.module.enable (attrContent.config or {});
        };
    in
      wrapTargetModule target validContent args;

    # combine all module imports into a single list
    moduleImports =
      # include the user defined imports as well
      imports
      ++ [
        # apply the user defined config to all systems only when the module is enabled
        (iglooTargetModule "global" {inherit config;})

        # apply the extra igloo config to all systems only when the module is enabled
        (iglooTargetModule "global" {config.igloo = igloo;})

        # apply the home manager passthrough to only nixos systems
        (iglooTargetModule "nixos" homePassthroughModule)

        # apply the packages to the correct config location for each system when the module is enabled
        (iglooTargetModule "nixos" {
          config.environment.systemPackages = packages;
        })
        (iglooTargetModule "home" {
          config.home.packages = packages;
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
