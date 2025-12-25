{
  lib,
  iglib,
  ...
}: let
  # a function that merges and replaces null values with defaults from another set
  mergeNulls = defaults: values:
    defaults
    // lib.mapAttrs (name: value:
      if value == null && defaults ? ${name}
      then defaults.${name}
      else value)
    values;

  # create a bind type for use in options
  # this defines a set of permission options for a file or directory
  # a bind type can be a simple string. this will use the default permissions
  # or the permissions can be defined explicitly using a set of attributes
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
          type = lib.types.str;
          default = null;
        };
        user = lib.mkOption {
          description = "The permission user to set for this bind";
          type = lib.types.str;
          default = null;
        };
        group = lib.mkOption {
          description = "The permission group to set for this bind";
          type = lib.types.str;
          default = null;
        };
      };
    })
  ];
in
  iglib.module {
    name = "persist";

    # set up options to be set by igloo users
    # these options are not used in the home config,
    # but is instead used by systems that wish to persist the files
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

    # nixos persists files using bind mounts
    # options are extracted from the user config to bind mount home files
    nixos = ctx: {
      options = {
        location = lib.mkOption {
          description = "The persistent store to bind files from";
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
        # default permissions for system files
        systemPerms = {
          mode = "0755";
          user = "root";
          group = "root";
        };

        # a function to build default permissions for user files
        mkUserPerms = user: {
          mode = systemPerms.mode;
          user = user;
          group = "users";
        };

        # a function that transforms a bind option to its long form
        # binds can be strings or attribute sets containing permissions
        # this ensures that the string version is transformed into its attr set version
        normalizeBind = defaultPerms: value:
          if lib.isAttrs value
          then mergeNulls defaultPerms value
          else defaultPerms // {target = value;};

        # build a function that generates a bash script for binding files
        # the `create` argument is expected to be a function that takes a single parameter
        # this is necessary because creating files or directories takes different commands
        # the rest of the script works regardless of the paths being files or directories
        bindScript = create: bind: let
          # map the target to its persistent source location
          target = lib.removePrefix "/" bind.target;
          source = "${ctx.module.location}/${target}";
        in ''
          # if the target does not exist, then it needs to be created
          if [[ ! -e "/${target}" ]]; then
            ${create target}
          fi

          # set the specified permissions for the target file
          # this always happens so that if the config changes the permissions the file gets updated
          chown ${bind.user}:${bind.group} "/${target}"
          chmod ${bind.mode} "/${target}"

          # if the source does not exist, then we can simply copy the target data to the source location
          # this ensures that if the target file existed already, then the existing contents are used
          if [[ ! -e ${source} ]]; then
            # we copy with `-a` here to duplicate all permissions and recursively copy directories as well
            cp -a "/${target}" "${source}"
          fi

          # check if the target and source are already bound together
          if findmnt -n -o SOURCE --target "/${target}" | grep -F -q "[${source}]"; then
            # if the mount is already correct, then we dont have to do anything
            :
          else
            # if the target is not mounted, or the mount is incorrect we should do it now
            # first, we need to unmount the file. we can ignore any failure here
            umount "/${target}" 2>/dev/null || true

            # then we need to bind the source to the target
            mount --bind "${source}" "/${target}"
          fi
        '';

        # function to build file and directory bind scripts
        # uses the `bindScript` function, and sets the `create` argument appropriately
        bindFileScript = bindScript (file: ''touch "/${file}"'');
        bindDirScript = bindScript (dir: ''mkdir -p "/${dir}"'');

        # create a list of normalized bind options for files and dirs
        # this transforms each bind option into its longform version with permissions
        sysFileBinds = map (item: normalizeBind systemPerms item) ctx.module.files;
        sysDirBinds = map (item: normalizeBind systemPerms item) ctx.module.dirs;
        mkUserFileBinds = user: map (item: normalizeBind (mkUserPerms user) item) (ctx.users.module user).files;
        mkUserDirBinds = user: map (item: normalizeBind (mkUserPerms user) item) (ctx.users.module user).dirs;

        # create the scripts for all file and directory binds
        sysFileBindScripts = lib.listToAttrs (map (bind: {
            name = "persist '${bind.target}'";
            value = {
              deps = ["users" "groups"];
              text = bindFileScript bind;
            };
          })
          sysFileBinds);
        sysDirBindScripts = lib.listToAttrs (map (bind: {
            name = "persist '${bind.target}'";
            value = {
              deps = ["users" "groups"];
              text = bindDirScript bind;
            };
          })
          sysDirBinds);

        # create functions that build the binds for user files and directories
        mkUserFileBindScripts = user:
          lib.listToAttrs (map (bind: {
            name = "persist ${user} '${bind.target}'";
            value = {
              deps = ["users" "groups"];
              text = bindFileScript (bind // {target = "/home/${user}/${bind.target}";});
            };
          }) (mkUserFileBinds user));
        mkUserDirBindScripts = user:
          lib.listToAttrs (map (bind: {
            name = "persist ${user} '${bind.target}'";
            value = {
              deps = ["users" "groups"];
              text = bindDirScript (bind // {target = "/home/${user}/${bind.target}";});
            };
          }) (mkUserDirBinds user));

        # generate and merge all the sys and user bind scripts together
        fileBindScripts =
          lib.foldl' (left: right: left // right) sysFileBindScripts
          (map mkUserFileBindScripts ctx.users.all);
        dirBindScripts =
          lib.foldl' (left: right: left // right) sysDirBindScripts
          (map mkUserDirBindScripts ctx.users.all);
      in {
        # merge all file and dir bind scripts into the activation scripts
        system.activationScripts = fileBindScripts // dirBindScripts;
      };
    };
  }
