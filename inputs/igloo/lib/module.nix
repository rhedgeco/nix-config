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

  # copied from
  # https://github.com/NixOS/nixpkgs/blob/d792a6e0cd4ba35c90ea787b717d72410f56dc40/lib/modules.nix#L590
  unifyModuleSyntax = file: key: m: let
    addMeta = config:
      if m ? meta
      then
        lib.mkMerge [
          config
          {meta = m.meta;}
        ]
      else config;
    addFreeformType = config:
      if m ? freeformType
      then
        lib.mkMerge [
          config
          {_module.freeformType = m.freeformType;}
        ]
      else config;
  in
    if m ? config || m ? options
    then let
      badAttrs = removeAttrs m [
        "_class"
        "_file"
        "key"
        "disabledModules"
        "imports"
        "options"
        "config"
        "meta"
        "freeformType"
      ];
    in
      if badAttrs != {}
      then throw "Igloo module `${key}` has an unsupported attribute `${lib.head (lib.attrNames badAttrs)}'. This is caused by introducing a top-level `config' or `options' attribute. Add configuration attributes immediately on the top level instead, or move all of them (namely: ${toString (lib.attrNames badAttrs)}) into the explicit `config' attribute."
      else {
        _file = toString m._file or file;
        _class = m._class or null;
        key = toString m.key or key;
        disabledModules = m.disabledModules or [];
        imports = m.imports or [];
        options = m.options or {};
        config = addFreeformType (addMeta (m.config or {}));
      }
    else
      # shorthand syntax
      lib.throwIfNot (lib.isAttrs m) "igloo module `${key}` does not look like a module." {
        _file = toString m._file or file;
        _class = m._class or null;
        key = toString m.key or key;
        disabledModules = m.disabledModules or [];
        imports = m.require or [] ++ m.imports or [];
        options = {};
        config = addFreeformType (
          removeAttrs m [
            "_class"
            "_file"
            "key"
            "disabledModules"
            "require"
            "imports"
            "freeformType"
          ]
        );
      };

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

    # define the global options
    # include an enable option to turn the whole module on or off
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
    # conditionally enables the config based on the modules `enable` status
    # and only compiles the module if the `target` matches the `iglooTarget`
    wrapIglooModule = target: content: systemArgs: let
      # get module and modules config from the systemArgs config
      module = moduleCfg systemArgs.config name;
      modules = systemArgs.igloo.modules;

      # import the content if it is a path
      importedContent =
        # if the content is a path is must be imported
        if lib.isPath content
        then import content
        # otherwise we can assume it is already imported
        else content;

      # resolve the imported content if it is a function
      resolvedContent =
        # if the imported content is a function, call it with the systemArgs
        if lib.isFunction importedContent
        # also pass in the `module` and `modules` settings for convenience
        then importedContent (systemArgs // {inherit module modules;})
        # otherwise we can assume that the imported content is already resolved
        else importedContent;

      # convert the module syntax into its longform style with config and options keys
      normalContent = unifyModuleSyntax __curPos.file "${name} -> ${toString target}" resolvedContent;

      # create the igloo content by nesting `config` and `options` keys
      iglooContent = {
        # nest the config in a conditional based the `module.enable` option
        config = lib.mkIf module.enable normalContent.config or {};

        # nest the options under the igloo modules name path
        options.igloo.modules = lib.setAttrByPath namePath (normalContent.options or {});
      };

      # merge the `iglooContent` back into the normalized content to replace the keys
      mergedContent = normalContent // iglooContent;
    in
      if target != "global"
      # if the target is not global, conditionally compile for that target
      then wrapTarget target mergedContent systemArgs
      # otherwise, just return the merged module content
      else mergedContent;
  in {
    imports = [
      # insert the global options module into every system
      globalOptions

      # pass through all system options values as the default for home manager
      (wrapTarget "nixos" homeManagerPassthrough)

      # create a global module with igloo config passed through
      (wrapIglooModule "global" {inherit igloo;})

      # create a global module with `imports`, `options`, and `config` passed through
      (wrapIglooModule "global" {inherit imports config;})

      # create system modules that pass the config through to their target
      (wrapIglooModule "nixos" nixos)
      (wrapIglooModule "home" home)

      # create a nixos module that populates the packages
      (wrapIglooModule "nixos" {
        environment.systemPackages = packages;
      })

      # create a home module that populates the packages
      (wrapIglooModule "home" {
        home.packages = packages;
      })
    ];
  };
in {
  inherit module moduleCfg;
}
