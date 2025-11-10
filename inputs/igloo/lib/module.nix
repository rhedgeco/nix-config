{lib, ...}: let
  # a function that gets an igloo modules config
  moduleCfg = config: name: let
    namePath = lib.splitString "." name;
  in
    lib.getAttrFromPath namePath config.igloo.modules;

  # a function that conditionally compiles a module if the target matches the `iglooTarget`
  wrapTarget = target: content: {iglooTarget, ...} @ systemArgs:
    if !(lib.isList target && builtins.elem iglooTarget target) && target != iglooTarget
    # id the igloo target doesnt match, return nothing
    then {}
    # if it does match, and its a function, then call it with the systemArgs
    else if lib.isFunction content
    then content systemArgs
    # otherwise, just return the content as it is
    else content;

  normalized = content: systemArgs: let
    # import the content
    importedContent =
      # if the content is a path is must be imported
      if lib.isPath content
      then import content
      # otherwise we can assume it is already imported
      else content;

    # resolve the imported content
    resolvedContent =
      # if the imported content is a function, call it with the systemArgs
      if lib.isFunction importedContent
      then importedContent systemArgs
      # otherwise we can assume that the imported content is already resolved
      else importedContent;

    # nix modules can either be in shorthand or longform
    # these are sets of keys that should only appear at the top level of a module, and not nested in a `config`
    # we can use this information to extract the items that are required to be at the top level when normalizing the content
    # https://github.com/NixOS/nixpkgs/blob/b3d51a0365f6695e7dd5cdf3e180604530ed33b4/lib/modules.nix#L614-L624
    longformKeys = ["_class" "_file" "key" "disabledModules" "imports" "options" "config" "meta" "freeformType"];
    longformContent = lib.filterAttrs (key: value: lib.elem key longformKeys) resolvedContent;
    shortformContent = lib.removeAttrs resolvedContent longformKeys;

    # normalize the content by nesting any shortform content inside the `config` key
    # to stay consistent with how nix evaluates modules and to keep errors somewhat sensible,
    # the module being in shortform vs longform is determined by there being a `config` or `option` top level key
    # https://github.com/NixOS/nixpkgs/blob/b3d51a0365f6695e7dd5cdf3e180604530ed33b4/lib/modules.nix#L612
    normalizedContent =
      if !(resolvedContent ? config || resolvedContent ? options)
      then longformContent // {config = shortformContent;}
      else resolvedContent;
  in
    normalizedContent;

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
    # expand the name to capture any period seperators
    namePath = lib.splitString "." name;

    # define the global options with an enable option by default
    globalOptions = {
      options.igloo.modules = lib.setAttrByPath namePath (
        {
          enable = lib.mkOption {
            type = lib.types.bool;
            description = "Enables the '${name}' igloo module.";
            default = enabled;
          };
        }
        # merge in the user defined options second, so the enable option can be overriden
        // options
      );
    };

    # define a module that copies all global options from the system into home manager
    homeManagerPassthrough = {config, ...}: let
      generatePassthrough = systemCfg: optionSet:
        lib.mapAttrs (
          optionName: optionValue: let
            # extract the value set in the system config
            systemValue = systemCfg.${optionName};
          in
            # if the value is of '_type' == 'option', then it is an leaf option value
            if (optionValue ? "_type" && optionValue._type == "option")
            # if the value is an leaf option, replace it with the system value as a default
            then lib.mkDefault systemValue
            # if its not a leaf, then its a parent and we need to link the nested options
            else generatePassthrough systemValue optionValue
        )
        optionSet;
    in {
      home-manager.sharedModules = [(generatePassthrough config globalOptions.options)];
    };

    # a function that nests all options under its `igloo.modules` route
    # and conditionally enables the config based on the modules `enable` status
    wrapIglooModule = content: systemArgs: let
      # get module config from the systemArgs config
      module = moduleCfg systemArgs.config name;

      # first the module must be normalized
      # also pass in the `module` and `modules` settings for convenience
      normalContent = normalized content (systemArgs // {inherit module;});

      # create the igloo content by nesting `config` and `options` keys
      iglooContent = {
        # nest the config in a conditional based the `module.enable` option
        config = lib.mkIf module.enable normalContent.config or {};

        # nest the options under the igloo modules name path
        options.igloo.modules = lib.setAttrByPath namePath (normalContent.options or {});
      };
    in
      # merge the `iglooContent` back into the normalized content to replace the keys
      normalContent // iglooContent;
  in {
    imports = [
      # insert the global options module into every system
      globalOptions

      # pass through all system options values as the default for home manager
      (wrapTarget "nixos" homeManagerPassthrough)

      # create a global module with igloo config passed through
      (wrapIglooModule {inherit igloo;})

      # create a global module with `imports`, `options`, and `config` passed through
      (wrapIglooModule {inherit imports config;})

      # create system modules that pass the config through to their target
      (wrapIglooModule (wrapTarget "nixos" nixos))
      (wrapIglooModule (wrapTarget "home" home))

      # create a nixos module that populates the packages
      (wrapIglooModule (wrapTarget "nixos" {
        environment.systemPackages = packages;
      }))

      # create a home module that populates the packages
      (wrapIglooModule (wrapTarget "home" {
        home.packages = packages;
      }))
    ];
  };
in {
  inherit module moduleCfg;
}
