{lib, ...}: let
  # a function that conditionally compiles a module if the target matches the `iglooTarget`
  wrapTarget = target: content: {iglooTarget, ...} @ systemArgs:
    if target != iglooTarget
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
    nixosEnabled ? false, # should this module be enabled by default on nixos targets
    homeEnabled ? false, # should this module be enabled by default on home targets
    igloo ? {}, # igloo configuration to apply to all targets (when enabled)
    imports ? [], # additional imports to apply to all targets (even if not enabled)
    options ? {}, # additional igloo module options to define on all targets (even if not enabled)
    config ? {}, # additional configuration to apply to all targets (when enabled)
    packages ? [], # packages to include on all targets (when enabled)
    nixos ? {}, # configuration to apply to only nixos targets (when enabled)
    home ? {}, # configuration to apply to only home targets (when enabled)
  }: let
    # a function for generating the module enable option with a default value
    enableOption = default: {
      options.igloo.modules."${name}".enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enables the '${name}' igloo module.";
        default = default;
      };
    };

    # a function that nests all options under its `igloo.modules` route
    # and conditionally enables the config based on the modules `enable` status
    wrapIglooModule = content: systemArgs: let
      # get common option paths to pass into module args
      modules = systemArgs.config.igloo.modules;
      module = modules."${name}";

      # first the module must be normalized
      # also pass in the `module` and `modules` settings for convenience
      normalContent = normalized content (systemArgs // {inherit module modules;});

      # create the igloo content by nesting `config` and `options` keys
      iglooContent = {
        # nest the options under the igloo module route
        options.igloo.modules."${name}" = normalContent.options or {};
        # nest the config in a conditional based the `module.enable` option
        config = lib.mkIf module.enable normalContent.config or {};
      };
    in
      # merge the `iglooContent` back into the normalized content to replace the keys
      normalContent // iglooContent;
  in {
    imports = [
      # generate the module enable option on nixos targets
      # set the default value to match then `enabled` or `nixosEnabled` module parameter
      (wrapTarget "nixos" (enableOption (enabled || nixosEnabled)))

      # generate the module enable option on home targets
      # set the default value to match then `enabled` or `homeEnabled` module parameter
      (wrapTarget "home" (enableOption (enabled || homeEnabled)))

      # create a global module with igloo parameters passed through
      (wrapIglooModule {inherit igloo;})

      # create a global module with `imports`, `options`, and `config` passed through
      (wrapIglooModule {inherit imports options config;})

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
  inherit module;
}
