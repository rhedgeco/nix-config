{den, ...}: {
  # include the create aspect by default for all users
  den.schema.user.includes = [den.aspects.create];

  # adds infrastructure for writing files/folders instead of linking
  den.aspects.create = {
    homeManager = {
      lib,
      pkgs,
      config,
      ...
    }: {
      options.create = lib.mkOption {
        description = "Files and folders to create for this user";
        type = with lib.types; attrsOf (oneOf [path str]);
        default = {};
      };

      config = {
        home.activation.den-create = let
          writeFileScript = target: source: let
            sourcePath =
              if lib.isString source
              then pkgs.writeText target source
              else source;
          in ''
            # create variables to store target and source locations
            TARGET="${config.home.homeDirectory}/${target}"
            SOURCE="${sourcePath}"

            # back up the target file if it already exists
            if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
              echo "Found existing file at $TARGET. Backing up..."
              rm -rf "$TARGET.backup"
              mv "$TARGET" "$TARGET.backup"
            fi

            # create the directory if it doesnt exist
            mkdir -p "$(dirname "$TARGET")"

            # copy the new file and set permissions
            verboseEcho "Creating $TARGET"
            run cp -r --no-preserve=mode "$SOURCE" "$TARGET"
            run chmod -R u+w "$TARGET"
          '';
        in
          lib.hm.dag.entryAfter ["writeBoundary"] (lib.concatStringsSep "\n" (
            lib.mapAttrsToList writeFileScript config.create
          ));
      };
    };
  };
}
