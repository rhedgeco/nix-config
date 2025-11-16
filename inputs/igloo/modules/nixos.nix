{
  lib,
  config,
  ...
}: {
  imports = [./global.nix];

  options.igloo = {
    enable = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "A list of modules to be enabled on the system";
      default = [];
    };
    userEnable = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "A list of modules to be enabled for every user";
      default = [];
    };
    userModules = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      description = "A collection of modules to add to every igloo user";
      default = [];
    };
  };

  config = {
    # use the igloo enable option to quickly enable all requested modules
    igloo.modules = lib.genAttrs config.igloo.enable (name: {
      enable = true;
    });

    # use the userEnable list to generate user configuration that enables all requested modules
    igloo.userModules =
      lib.map (
        name: {
          igloo.modules."${name}".enable = true;
        }
      )
      config.igloo.userEnable;
  };
}
