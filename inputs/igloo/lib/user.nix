{lib, ...}: let
  # a function that builds home manager configurations for a user
  mkUserHome = {
    name,
    modules ? [],
    extraConfig ? {},
  }: {...}: rec {
    # pass all the modules into the imports for the user
    # also inherit the extra user configuration settings
    imports = modules ++ [({...}: {config = extraConfig;})];

    # set every users name to match their directory by default
    home.username = lib.mkDefault "${name}";

    # set each users home directory to the standard path by default
    home.homeDirectory = lib.mkDefault "/home/${home.username}";

    # let home manager install and manage itself by default
    programs.home-manager.enable = lib.mkDefault true;
  };

  # a function that builds a system module that can enable home manager users
  mkUserModule = {
    name,
    modules ? [],
  }: {config, ...}: let
    userOptions = config.igloo.users."${name}";
  in {
    # build the options that can enable and configure the user
    options.igloo.users."${name}" = {
      enable = lib.mkEnableOption "Enables the '${name}' igloo user";
      config = lib.mkOption {
        type = lib.types.attrs;
        description = "Extra system config settings to add to the '${name}' user";
        default = {};
      };
      homeImports = lib.mkOption {
        type = lib.types.listOf lib.types.anything;
        description = "Extra imports to add to the '${name}' users home configuration";
        default = [];
      };
      homeConfig = lib.mkOption {
        type = lib.types.attrs;
        description = "Extra config settings to add to the '${name}' users home configuration";
        default = {};
      };
    };

    # create home manager configuration for user if its enabled
    config = lib.mkIf userOptions.enable {
      # set up normal system user
      users.users."${name}" =
        {
          isNormalUser = true;
        }
        // userOptions.config;

      home-manager = {
        # set up user using mkUserHome function
        users."${name}" = mkUserHome {
          name = "${name}";
          modules = modules ++ userOptions.homeImports;
          extraConfig = userOptions.homeConfig;
        };
      };
    };
  };
in {
  inherit mkUserHome mkUserModule;
}
