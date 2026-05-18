{
  den.default = {
    homeManager = {
      lib,
      pkgs,
      config,
      ...
    }: {
      options.scribe = lib.mkOption {
        description = "Files and folders to scribe for this user";
        type = with lib.types; attrsOf (either path str);
        default = {};
      };

      config = {
        # overwite the scribed files every time the home activates
        # this allows users to edit the file in place, perhaps with a settings gui
        # and if they want to keep the changed settings, it has to be propogated to their nix config
        home.activation.scribeWrite = let
          writeFileScript = target: source: ''
            TARGET="${config.home.homeDirectory}/${target}"
            SOURCE="${
              if lib.isString source
              then pkgs.writeText (baseNameOf target) source
              else source
            }"

            if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
              echo "Found existing file at $TARGET. Removing..."
              rm -rf "$TARGET"
            fi

            mkdir -p "$(dirname "$TARGET")"
            verboseEcho "Creating $TARGET"
            run cp -r --no-preserve=mode "$SOURCE" "$TARGET"
            run chmod -R u+w "$TARGET"
          '';
        in
          lib.hm.dag.entryAfter ["writeBoundary"] (lib.concatStringsSep "\n" (
            lib.mapAttrsToList writeFileScript config.scribe
          ));
      };
    };
  };
}
