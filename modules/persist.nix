{
  lib,
  iglib,
  inputs,
  ...
}: let
  # define a option type that represents a persistent bind
  # a bind type can be a single string, or a set of attributes
  bindType = lib.types.oneOf [
    lib.types.str
    (lib.types.submodule {
      options = {
        target = lib.mkOption {
          description = "The target location to bind to";
          type = lib.types.str;
        };
        mode = lib.mkOption {
          description = "The permission mode to set for this bind";
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
        user = lib.mkOption {
          description = "The permission user to set for this bind";
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
        group = lib.mkOption {
          description = "The permission group to set for this bind";
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
      };
    })
  ];

  # a function that can map a bind type to what impermanence expects
  mapBind = key: bind: let
    resolve = key:
      if lib.isAttrs bind && bind ? ${key} && bind.${key} != null
      then {${key} = bind.${key};}
      else {};
  in
    {
      ${key} =
        if lib.isAttrs bind
        then bind.target
        else bind;
    }
    // (resolve "mode")
    // (resolve "user")
    // (resolve "group");
in
  iglib.module {
    name = "persist";

    # allow home manager users to define persistent bind locations
    # these will not be used by the home manager impermanece module
    # but rather use a more efficient bind method at the nixos level
    # the nixos portion of this module can inspect the home manager settings for each user
    # and then use that information to execute the bind mounts in nixos
    home.options = {
      files = lib.mkOption {
        description = "Home file targets to bind from persistent storage";
        type = lib.types.listOf bindType;
        default = [];
      };
      dirs = lib.mkOption {
        description = "Home directory targets to bind from persistent storage";
        type = lib.types.listOf bindType;
        default = [];
      };
    };

    nixos = ctx: {
      # use the impermanence nixos module for most of the environment persistence
      imports = [inputs.impermanence.nixosModules.impermanence];

      options = {
        location = lib.mkOption {
          description = "The path prefix to store all other files in by default";
          type = lib.types.str;
        };
        files = lib.mkOption {
          description = "File targets to bind from persistent storage";
          type = lib.types.listOf bindType;
          default = [];
        };
        dirs = lib.mkOption {
          description = "Directory targets to bind from persistent storage";
          type = lib.types.listOf bindType;
          default = [];
        };
      };

      enabled = {
        environment.persistence."${ctx.module.location}" = {
          # hide all these bind mounts from things like the file explorer
          hideMounts = true;

          # map persist files to impermanence files
          files = map (mapBind "file") ctx.module.files;

          # map persist dirs to impermanence directories
          directories = map (mapBind "directory") ctx.module.dirs;

          # generate all the binds defined by every home manager user
          users = ctx.users.genAll (name: {
            files = map (mapBind "file") (ctx.users.module name).files;
            directories = map (mapBind "directory") (ctx.users.module name).dirs;
          });
        };
      };
    };
  }
