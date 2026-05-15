{
  lib,
  inputs,
  ...
}: let
  # utility functions for getting schema info
  hasStore = host: host.persist.store != null;

  # define persist options on home-manager users
  persistUser = {
    host,
    user,
    ...
  }:
    lib.optionalAttrs (hasStore host && user.persist) {
      homeManager = {
        options.persist = {
          directories = lib.mkOption {
            description = "User directories to persist.";
            type = lib.types.listOf lib.types.anything;
            default = [];
          };

          files = lib.mkOption {
            description = "User files to persist.";
            type = lib.types.listOf lib.types.anything;
            default = [];
          };
        };
      };
    };

  # import impermanence and define persist options on nixos hosts
  persistHost = {host, ...}:
    lib.optionalAttrs (hasStore host) {
      nixos = {config, ...}: {
        imports = [inputs.impermanence.nixosModules.impermanence];

        options.persist = {
          directories = lib.mkOption {
            description = "System directories to persist.";
            type = lib.types.listOf lib.types.anything;
            default = [];
          };

          files = lib.mkOption {
            description = "System files to persist.";
            type = lib.types.listOf lib.types.anything;
            default = [];
          };
        };

        # pass all 'persist' configuration to impermanence
        config.environment.persistence.${host.persist.store} = {
          inherit (config.persist) directories files;

          # propagate each home-manager user's persist options up to the system level
          users = lib.mapAttrs (_name: userCfg: {
            inherit (userCfg.persist) directories files;
          }) (lib.filterAttrs (_: userCfg: userCfg ? persist) (config.home-manager.users or {}));
        };
      };
    };
in {
  den.schema.host = {
    includes = [persistHost];
    options.persist.store = lib.mkOption {
      description = "Path to persistent storage location.";
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  den.schema.user = {
    includes = [persistUser];
    options.persist = lib.mkOption {
      description = "Enable user to persist its home directory items.";
      type = lib.types.bool;
      default = false;
    };
  };
}
