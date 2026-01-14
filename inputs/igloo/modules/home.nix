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

        # skip creating the target if it already exists
        if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
          echo "Skipping igloo create $TARGET. Already exists."
        else
          # create the directory if it doesnt exist
          mkdir -p "$(dirname "$TARGET")"

          # copy the new file and set permissions
          verboseEcho "Creating $TARGET"
          run cp -r --no-preserve=mode "$SOURCE" "$TARGET"
          run chmod -R u+w "$TARGET"
        fi
      '';
    in
      lib.hm.dag.entryAfter ["writeBoundary"] (lib.concatStringsSep "\n" (
        lib.mapAttrsToList writeFileScript config.igloo.create
      ));
  };
}
