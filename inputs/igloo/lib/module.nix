{lib, ...}: let
  genTargetModule = name: target: content: {iglooTarget ? "unknown", ...} @ systemArgs: let
    # collect igloo modules configuration options
    iglooModules = systemArgs.config.igloo.module;
    iglooModule = iglooModules."${name}";

    # resolve the module content using the systemArgs
    # also pass in the module and modules parameter for easy access
    resolved = content (systemArgs // {inherit iglooModules iglooModule;});

    # build the final module using the resolved content
    finalModule = {
      # place the options under the igloo options route
      options.igloo.module."${name}" = resolved.options or {};
      # then strip the options and import the rest of the config
      imports = [(lib.attrsets.removeAttrs resolved ["options"])];
    };
  in
    # only apply the igloo module if the iglooTarget matches
    # if the target is set to 'global', then it should work for all targets
    if target == "global" || iglooTarget == target
    then finalModule
    else {};

  # a function that generates the igloo target modules for each kind of system
  module = {
    name,
    enable ? false,
    global ? {...}: {},
    nixos ? {...}: {},
    user ? {...}: {},
  }: {
    options.igloo.module."${name}" = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enables the '${name}' igloo module.";
        default = enable;
      };
    };

    imports = [
      (genTargetModule name "global" global)
      (genTargetModule name "nixos" nixos)
      (genTargetModule name "user" user)
    ];
  };
in {
  inherit module;
}
