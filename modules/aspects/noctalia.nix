{ lib, inputs, ... }: {
  den.aspects.noctalia.homeManager = { pkgs, config, ... }: {
    options.den.noctalia = {
      config = lib.mkOption {
        description = "files to include in the noctalia config dir";
        type =
          with lib.types;
          attrsOf (oneOf [
            path
            str
          ]);
        default = { };
      };
      share = lib.mkOption {
        description = "files to include in the noctalia share";
        type =
          with lib.types;
          attrsOf (oneOf [
            path
            str
          ]);
        default = { };
      };
    };

    config = {
      home.packages = [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      # create the empty setup complete file
      # this prevents the welcome banner from appearing
      den.noctalia.config.".setup-complete" = "";

      persist.dirs = [
        # only persist the calendar part of the cache
        # so calendar events persist without network
        ".cache/noctalia/calendar"
      ];

      # write all the included files to the noctalia directory
      den.create =
        let
          config-files = lib.mapAttrs' (name: content: {
            name = ".config/noctalia/${name}";
            value = if lib.isString content then pkgs.writeText name content else content;
          }) config.den.noctalia.config;

          share-files = lib.mapAttrs' (name: content: {
            name = ".local/share/noctalia/${name}";
            value = if lib.isString content then pkgs.writeText name content else content;
          }) config.den.noctalia.share;
        in
        config-files // share-files;
    };
  };
}
