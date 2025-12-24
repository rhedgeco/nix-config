{
  lib,
  pkgs,
  iglib,
  ...
}: let
  defaultCommand = "${pkgs.bash}/bin/bash --login";
in
  iglib.module {
    name = "greetd";

    home.options.command = lib.mkOption {
      type = lib.types.str;
      description = "The command to run when greetd launches this user";
      default = defaultCommand;
    };

    nixos = ctx: {
      options.autoLogin = lib.mkOption {
        type = lib.types.str;
        description = "Automatically logs in this user at startup";
      };

      enabled = {
        services.greetd = {
          enable = true;
          settings = {
            initial_session = lib.mkIf (ctx.module ? autoLogin) {
              command = (ctx.users.module ctx.module.autoLogin).command;
              user = ctx.module.autoLogin;
            };
            default_session = {
              command = "${pkgs.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time --cmd '${defaultCommand}'";
              user = "greeter";
            };
          };
        };
      };
    };
  }
