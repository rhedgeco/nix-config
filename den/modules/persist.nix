{
  lib,
  inputs,
  den,
  ...
}: {
  # all a user has to decide, is if their data will be persisted
  den.schema.user = {
    options.persist = lib.mkEnableOption "whether to persist this user data or not";
  };

  # a host has to define the location that all system and user data will persist to
  den.schema.host = {
    options.persist = lib.mkOption {
      description = "the location to collect from and persist system data to";
      type = with lib.types; nullOr str;
      default = null;
    };
  };

  # nixos persistence can simple be forwarded to impermanence
  den.aspects.persist-nixos = {
    nixos = {
      host,
      config,
      ...
    }:
      lib.optionalAttrs (host.persist != null) {
        # ensure the impermanence module is imported on nixos system
        imports = [inputs.impermanence.nixosModules.impermanence];

        # persist some files by default always
        persist = {
          files = [
            "/etc/machine-id"
          ];
          dirs = [
            "/var/log" # system log files
            "/var/lib/nixos" # needed for nixos systems
            "/var/lib/systemd/coredump" # systemd coredump info
          ];
        };

        # use impermanence for persisting system data
        environment.persistence."${host.persist}" = {
          # hide bind mounts from things like the file explorer
          hideMounts = true;

          # propogate persist.* files and dirs to impermanence
          files = config.persist.files;
          directories = config.persist.dirs;
        };
      };
  };

  # on nixos, users persistence data should be propogated up to the system
  # this allows user files to be bind mounted instead of fuse mounted
  # bind mounting is more performant than user level fuse mounting
  den.aspects.persist-nixos-user = {
    nixos = {
      host,
      user,
      config,
      ...
    }:
      lib.optionalAttrs (host.persist != null && user.persist) {
        environment.persistence.${host.persist}.users.${user.name} = {
          # propogate the user persist.* files and dirs to impermanence
          files = config.home-manager.users.${user.name}.persist.files;
          directories = config.home-manager.users.${user.name}.persist.dirs;
        };
      };
  };

  den.default = let
    # all systems will use the same simple persist config structure
    persistOption = lib.mkOption {
      description = "persist configuration settings";
      default = {};
      type = lib.types.submodule {
        options = {
          dirs = lib.mkOption {
            description = "directories to persist";
            type = with lib.types; listOf raw;
            default = [];
          };
          files = lib.mkOption {
            description = "directories to persist";
            type = with lib.types; listOf raw;
            default = [];
          };
        };
      };
    };
  in {
    # all systems should come with the persist options
    # how they are handled may be different in each scenario
    homeManager.options.persist = persistOption;
    nixos.options.persist = persistOption;

    # include the aspects that implement the persist behavior
    includes = [
      den.aspects.persist-nixos
      den.aspects.persist-nixos-user
    ];
  };
}
