{
  lib,
  config,
  ...
}: let
  cfg = config.igloo;
in {
  options.igloo = {
    enableModules = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Enables all igloo modules in the list";
      default = [];
    };
    disableModules = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Disables all igloo modules in the list";
      default = [];
    };
  };

  imports = [
    {
      igloo.modules = lib.listToAttrs (lib.map (name: {
          inherit name;
          value.enable = true;
        })
        cfg.enableModules);
    }
    {
      igloo.modules = lib.listToAttrs (lib.map (name: {
          inherit name;
          value.enable = false;
        })
        cfg.disableModules);
    }
  ];
}
