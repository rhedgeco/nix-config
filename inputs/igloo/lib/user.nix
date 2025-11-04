{lib, ...}: let
  # a function that builds home manager configurations for a user
  homeUser = {
    name,
    config ? {},
    modules ? [],
  }: {
    # pass all the modules into the imports for the user
    # also inherit the extra user configuration settings
    imports = modules ++ [config];

    # set every users name to match their directory by default
    home.username = lib.mkDefault "${name}";

    # set each users home directory to the standard path by default
    home.homeDirectory = lib.mkDefault "/home/${name}";

    # let home manager install and manage itself by default
    programs.home-manager.enable = lib.mkDefault true;
  };

  # a function that builds a system module that can enable home manager users
  homeUserModule = {
    name,
    modules ? [],
  }: {config, ...}: let
    userOptions = config.igloo.users."${name}";
  in {
    # build the options that can enable and configure the user
    options.igloo.users."${name}" = {
      enable = lib.mkEnableOption "Enables the '${name}' igloo user";
      modules = lib.mkOption {
        type = lib.types.listOf lib.types.anything;
        description = "Extra modules to add to the '${name}' users home configuration";
        default = [];
      };
      systemConfig = lib.mkOption {
        type = lib.types.attrs;
        description = "Extra system configuration to add to the '${name}' user";
        default = {};
      };
      homeConfig = lib.mkOption {
        type = lib.types.attrs;
        description = "Extra home-manager configuration to add to the '${name}' user";
        default = {};
      };
    };

    # create home manager configuration for user if its enabled
    config = lib.mkIf userOptions.enable {
      # set up normal system user
      users.users."${name}" =
        userOptions.systemConfig
        // {isNormalUser = true;};

      home-manager = {
        # set up user using mkUserHome function
        users."${name}" = homeUser {
          name = "${name}";
          config = userOptions.homeConfig;
          modules = modules ++ userOptions.modules;
        };
      };
    };
  };
in {
  inherit homeUser homeUserModule;
}
