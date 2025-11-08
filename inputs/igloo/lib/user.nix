{lib, ...}: let
  # a function that gets a igloo users config
  userCfg = config: name: config.igloo.users."${name}";

  # a function that builds home manager configurations for a user
  homeUser = {
    name,
    modules ? [],
  }: {
    # pass all the modules into the imports for the user
    # also inherit the extra user configuration settings
    imports = modules;

    # set every users name to match their directory by default
    home.username = lib.mkDefault "${name}";

    # set each users home directory to the standard path by default
    home.homeDirectory = lib.mkDefault "/home/${name}";

    # let home manager install and manage itself by default
    programs.home-manager.enable = lib.mkDefault true;
  };

  # a function that builds a system module to manage a specific user
  userModule = {
    name,
    modules ? [],
  }: {config, ...}: let
    cfg = userCfg config name;
    userImports = config.igloo.users.imports;
  in {
    options.igloo.users."${name}" = {
      enable = lib.mkEnableOption "Enables the '${name}' igloo user";
      config = lib.mkOption {
        type = lib.types.attrs;
        description = "Extra nixos configuration to add to the '${name}' user";
        default = {};
      };
      iglooModules = lib.mkOption {
        type = lib.types.attrs;
        description = "Extra igloo module config to add to the '${name}' users home configuration";
        default = {};
      };
      imports = lib.mkOption {
        type = lib.types.listOf lib.types.anything;
        description = "Extra imports to add to the '${name}' users home configuration";
        default = [];
      };
    };

    config = lib.mkIf cfg.enable {
      # apply the user system settings
      # then merge with isNormalUser to ensure it always is true
      users.users."${name}" = cfg.config // {isNormalUser = true;};

      # set up users home manager
      home-manager = {
        users."${name}" = homeUser {
          name = "${name}";
          modules =
            # include the modules for this user
            modules
            # include extra imports for every user
            ++ userImports
            # include extra imports defined in the system
            ++ cfg.imports
            # include extra igloo config defined in the system
            ++ [{igloo.modules = cfg.iglooModules;}];
        };
      };
    };
  };
in {
  inherit homeUser userModule userCfg;
}
