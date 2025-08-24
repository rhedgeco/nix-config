{
  lib,
  config,
  ...
}: let
  session = config.custom.greetd.autoLogin.command;
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
in {
  options.custom.greetd = {
    enable = lib.mkEnableOption "enable greetd greeter";

    autoLogin = {
      command = lib.mkOption {
        type = lib.types.str;
        description = "Select what command to run on autologin";
      };
      user = lib.mkOption {
        type = lib.types.str;
        description = "Select which user to autologin";
      };
    };
  };

  config = lib.mkIf config.custom.greetd.enable {
    services.greetd = {
      enable = true;
      settings = {
        # autologin user by default
        initial_session = {
          command = session;
          user = config.custom.greetd.autoLogin.user;
        };

        # when logging out show a tuigreet prompt instead
        default_session = {
          command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time -cmd ${session}";
          user = "greeter";
        };
      };
    };
  };
}
