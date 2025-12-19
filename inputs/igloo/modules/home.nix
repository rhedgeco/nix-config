{
  lib,
  config,
  ...
}: {
  imports = [./global.nix];

  options.igloo.create = lib.mkOption {
    description = "Files and folders to create for this user";
    type = lib.types.attrsOf lib.types.path;
    default = {};
  };

  config = {
    home.activation.iglooCreate = let
      writeFileScript = target: source: ''
        # create variables to store target and source locations
        TARGET="${config.home.homeDirectory}/${target}"
        SOURCE="${source}"

        # create the directory if it doesnt exist
        mkdir -p "$(dirname "$TARGET")"

        # delete any existing files at the target
        if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
          verboseEcho "Overwriting existing $TARGET"
          run rm -rf "$TARGET"
        fi

        # copy the new file and set permissions
        verboseEcho "Creating $TARGET"
        run cp -r --no-preserve=mode "$SOURCE" "$TARGET"
        run chmod -R u+w "$TARGET"
      '';
    in
      lib.hm.dag.entryAfter ["writeBoundary"] (lib.concatStringsSep "\n" (
        lib.mapAttrsToList writeFileScript config.igloo.create
      ));
  };
}
