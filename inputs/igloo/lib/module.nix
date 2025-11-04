{lib, ...}: let
  genTargetModule = name: target: content: {iglooTarget ? "unknown", ...} @ systemArgs: let
    # collect igloo modules configuration options
    iglooModules = systemArgs.config.igloo.modules;
    iglooModule = iglooModules."${name}";

    # resolve the module content using the systemArgs if its a function
    # pass in the iglooModule and iglooModules parameters for easy access
    resolvedContent =
      if builtins.isAttrs content
      then content
      else if builtins.isFunction content
      then content (systemArgs // {inherit iglooModules iglooModule;})
      else throw "genTargetModule content is not a function or an attribute set";

    # there are also top level special keys that need to be managed correctly and not stuffed in a config
    specialKeys = ["_class" "_file" "key" "disabledModules" "imports" "options" "config" "meta" "freeformType"];
    specialContent = lib.filterAttrs (key: value: lib.elem key specialKeys) resolvedContent;
    unspecialContent = lib.removeAttrs resolvedContent specialKeys;

    # extract the options content and place them under the igloo modules route
    optionContent = {
      options.igloo.modules."${name}" = resolvedContent.options or {};
    };

    # normalize the config content based on if the content is shorthand or not
    normalizedContent =
      # first we detect if the module is in shorthand format
      # this is determined if there is either an `options` or a `config` key at the top level
      if !(resolvedContent ? options || resolvedContent ? config)
      # if the content is in shorthand, then we can just wrap all the unspecial content with `config`
      then {config = lib.mkIf iglooModule.enable unspecialContent;}
      # if it is shorthand, we have to wrap the resolved config key and merge it with the unspecial content
      else unspecialContent // {config = lib.mkIf iglooModule.enable (resolvedContent.config or {});};
  in
    # only apply the module content if the iglooTarget matches
    # however, if the target is set to 'global' then it should always apply
    if target == "global" || iglooTarget == target
    then specialContent // optionContent // normalizedContent
    else {};

  # a function that generates the igloo target modules for each kind of system
  module = {
    name,
    enabled ? true,
    options ? {},
    igloo ? {},
    packages ? [],
    global ? {},
    nixos ? {},
    user ? {},
  }: {
    options.igloo.modules."${name}" = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enables the '${name}' igloo module.";
        default = enabled;
      };
    };

    imports = [
      # generate global module for all systems
      (genTargetModule name "global" {
        inherit options; # pass through the options directly
        config.igloo = igloo; # apply igloo settings to `config.igloo`
      })

      # pass system modules through with respective target
      (genTargetModule name "global" global)
      (genTargetModule name "nixos" nixos)
      (genTargetModule name "user" user)

      # pass packages to all nixos systems
      (genTargetModule name "nixos" {
        environment.systemPackages = packages;
      })

      # pass packages to all user systems
      (genTargetModule name "user" {
        home.packages = packages;
      })
    ];
  };
in {
  inherit module;
}
