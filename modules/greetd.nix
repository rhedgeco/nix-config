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

    nixos = {iglooCtx, ...}: {
      options.autoLogin = lib.mkOption {
        type = lib.types.str;
        description = "Automatically logs in this user at startup";
      };

      enabled = {
        services.greetd = {
          enable = true;
          settings = {
            initial_session = lib.mkIf (iglooCtx.module ? autoLogin) {
              command = (iglooCtx.users.module iglooCtx.module.autoLogin).command;
              user = iglooCtx.module.autoLogin;
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
