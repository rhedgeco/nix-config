{
  lib,
  iglib,
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
        source = lib.mkOption {
          description = "The source location to bind to the target";
          type = lib.types.nullOr lib.types.str;
          default = null;
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
in
  iglib.module {
    name = "persist";

    # allow home manager users to define persistent bind locations
    # home-manager cannot itself execute any bind mounts (since bind mounting requires root)
    # but they can be defined here and any system that can see these options can take advantage
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

    # on nixos systems, we will also define persistent bind locations
    # during this process we can also check for home manager users bind paths
    nixos = ctx: {
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

      enabled = let
        # default permissions for system binds
        bindDefaults = {
          prefix = "";
          mode = "0755";
          user = "root";
          group = "root";
        };

        # a function that generates a normalized bind set
        normalizeBind = defaults: type: bind: let
          # a function that forces any string to start with a '/' prefix
          forceSlash = path:
            if lib.hasPrefix "/" path
            then path
            else "/${path}";

          # a function that resolves a key from the bind
          # if its null or doesnt exist, it instead uses a default value
          resolve = key: default:
            if lib.isAttrs bind && bind ? ${key} && bind.${key} != null
            then bind.${key}
            else default;

          # extract the target from the bind
          # ensure the target always starts with a slash prefix
          unprefixTarget = forceSlash (resolve "target" bind);
          target = forceSlash "${defaults.prefix}${unprefixTarget}";

          # extract the source from the bind
          # if it doesnt exist, calculate the source location
          source = forceSlash (
            resolve "source" "${ctx.module.location}${target}"
          );
        in {
          # pass through the is file boolean
          # use the calculated target and source
          # define defaults for file permissions
          inherit type target source;
          mode = resolve "mode" defaults.mode;
          user = resolve "user" defaults.user;
          group = resolve "group" defaults.group;
        };

        # a function to generate a script that sets up a bind mount
        mkBindScript = bind: ''
          # if the target does not exist, then it needs to be created
          if [[ ! -e "${bind.target}" ]]; then
          ${
            if bind.type == "file"
            then ''touch "${bind.target}"''
            else ''mkdir -p ${bind.target}''
          }
          fi

          # set the specified permissions for the target file
          # this always happens so that if the config changes the permissions the file gets updated
          chown ${bind.user}:${bind.group} "${bind.target}"
          chmod ${bind.mode} "${bind.target}"

          # if the source does not exist, then we can simply copy the target data to the source location
          # this ensures that if the target file existed already, then the existing contents are used
          if [[ ! -e ${bind.source} ]]; then
            # we copy with `-a` here to duplicate all permissions and recursively copy directories as well
            cp -a "${bind.target}" "${bind.source}"
          fi

          # check if the target and source are already bound together
          echo "binding '${bind.source}' to '${bind.target}' ..."
          if ! findmnt -n -o SOURCE --target "${bind.target}" | grep -F -q "[${bind.source}]"; then
            # if the target is not mounted, or the mount is incorrect we should mount it now
            # first, we need to unmount any current binds. we can ignore any failures here
            umount "${bind.target}" 2>/dev/null || true

            # then we need to bind the source to the target
            echo "binding '${bind.source}' to '${bind.target}' ..."
            mount --bind "${bind.source}" "${bind.target}"
          fi
        '';

        # generate normalized binds for system files and dirs
        fileBinds = map (bind: normalizeBind bindDefaults "file" bind) ctx.module.files;
        dirBinds = map (bind: normalizeBind bindDefaults "dir" bind) ctx.module.dirs;

        # generate normalized binds for user files and dirs
        userBinds = lib.concatLists (
          map (
            user: let
              userPerms = {
                prefix = "/home/${user}";
                mode = bindDefaults.mode;
                user = "${user}";
                group = "users";
              };
              fileBinds = map (bind: normalizeBind userPerms "file" bind) (ctx.users.module user).files;
              dirBinds = map (bind: normalizeBind userPerms "dir" bind) (ctx.users.module user).dirs;
            in
              fileBinds ++ dirBinds
          )
          ctx.users.all
        );

        # generate all activation scripts from all bind sets
        bindActivationScripts = lib.listToAttrs (
          map (bind: {
            name = "bind '${bind.source}' to '${bind.target}'";
            value = {
              deps = ["users" "groups"];
              text = mkBindScript bind;
            };
          }) (fileBinds ++ dirBinds ++ userBinds)
        );
      in {
        system.activationScripts = bindActivationScripts;
      };
    };
  }
