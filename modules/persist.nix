{
  lib,
  iglib,
  ...
}: let
  # a function that replaces null values with defaults from another set
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
        defaultPerms = {
          mode = "0755";
          user = "root";
          group = "root";
        };

        # a function that transforms a bind option to its long form
        # binds can be strings or attribute sets containing permissions
        # this ensures that the string version is transformed into its attr set version
        normalizeBind = value:
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
          # if the source and target exist
          # check if the bind mount is already complete
          if [[ -e "${source}" && -e "/${target}" ]]; then
            # extract the current bind source (empty if not bind mounted)
            # and check if the path binds to the source we expect
            if findmnt -n -o SOURCE --target "/${target}" | grep -F -q "[${source}]"; then
              # if the mount is already correct, then we can just exit now
              exit 0
            fi

            # otherwise we need to ensure that the target is not bind mounted
            umount "/${target}" 2>/dev/null || true
          fi

          # if the source does not exist, but the target does
          # then we can simply copy the target data to the source location
          if [[ ! -e "${source}" && -e "/${target}" ]]; then
            cp -a "/${target}" "${source}"
          fi

          # if the source does not exist, then it needs to be created
          if [[ ! -e "${source}" ]]; then
            ${create source}
          fi

          # set the specified permissions for the source file
          chown ${bind.user}:${bind.group} "${source}"
          chmod ${bind.mode} "${source}"

          # if the target does not exist, then it needs to be created
          if [[ ! -e "/${target}" ]]; then
            ${create target}
          fi

          # set the specified permissions for the target file
          # (this is not necessary, but it can make things less confusing when unmounting)
          chown ${bind.user}:${bind.group} "/${target}"
          chmod ${bind.mode} "/${target}"

          # bind mount the source to the target location
          mount --bind "${source}" "/${target}"
        '';

        # function to build file and directory bind scripts
        # uses the `bindScript` function, and sets the `create` argument appropriately
        bindFileScript = bindScript (file: ''touch "/${file}"'');
        bindDirScript = bindScript (dir: ''mkdir -p "/${dir}"'');

        # create a list of normalized bind options for files and dirs
        # this transforms each bind option into its longform version with permissions
        fileBinds = map (item: normalizeBind item) ctx.module.files;
        dirBinds = map (item: normalizeBind item) ctx.module.dirs;

        # create the scripts for all file binds
        fileBindScripts = lib.listToAttrs (map (bind: {
            name = "persist '${bind.target}'";
            value = {
              deps = ["users" "groups"];
              text = bindFileScript bind;
            };
          })
          fileBinds);

        # create the scripts for all directory binds
        dirBindScripts = lib.listToAttrs (map (bind: {
            name = "persist '${bind.target}'";
            value = {
              deps = ["users" "groups"];
              text = bindDirScript bind;
            };
          })
          dirBinds);
      in {
        # merge all file and dir bind scripts into the activation scripts
        system.activationScripts = fileBindScripts // dirBindScripts;
      };
    };
  }
