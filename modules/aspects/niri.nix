{ lib, ... }: {
  den.aspects.niri = {
    homeManager = { pkgs, config, ... }: {
      options.den.niri = {
        include = lib.mkOption {
          description = "files to include in the niri config";
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
        # include the niri package in the environment
        home.packages = [ pkgs.niri ];

        # generate all the config files
        den.create =
          let
            # get all the included config
            includes = config.den.niri.include;

            # build default niri configuration
            defaultConfig = {
              ".config/niri/default" = ./_assets/niri;
            };

            # convert the name into the niri config path
            # and normalize the string content into store paths
            userConfig = lib.mapAttrs' (name: content: {
              name = ".config/niri/${name}";
              value = if lib.isString content then pkgs.writeText name content else content;
            }) includes;

            # create the base niri config that links everything together
            baseConfig.".config/niri/config.kdl" = pkgs.writeText "config.kdl" ''
              // default niri config defined in den
              include "default/include.kdl"

              // user configuration
              ${lib.concatMapAttrsStringSep "\n" (name: _: ''include "./${name}"'') includes}
            '';
          in
          # merge the sets together to write all niri config
          baseConfig // defaultConfig // userConfig;
      };
    };
  };
}
