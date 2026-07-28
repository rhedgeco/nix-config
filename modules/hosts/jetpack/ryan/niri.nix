{lib, ...}: {
  den.aspects.jetpack.provides.ryan.homeManager = {
    pkgs,
    config,
    ...
  }: {
    options.niri.include = lib.mkOption {
      description = "files to include in the niri config";
      type = with lib.types; attrsOf (oneOf [path str]);
      default = {};
    };

    config = {
      # include all custom niri files by default
      niri.include = let
        kdlFiles =
          lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".kdl" name)
          (builtins.readDir ./_assets/niri);
      in
        lib.mapAttrs' (name: _: {
          name = name;
          value = ./_assets/niri/${name};
        })
        kdlFiles;

      # generate all the config files
      create = let
        # get all the included config
        includes = config.niri.include;

        # convert the name into the niri config path
        # and normalize the string content into store paths
        createSet =
          lib.mapAttrs' (name: content: {
            name = ".config/niri/${name}";
            value =
              if lib.isString content
              then pkgs.writeText name content
              else content;
          })
          includes;

        # create the base niri config that links everything together
        createConfig.".config/niri/config.kdl" = pkgs.writeText "config.kdl" ''
          ${
            lib.concatMapAttrsStringSep "\n"
            (name: _: ''include "./${name}"'')
            includes
          }
        '';
      in
        # merge the sets together to write all niri config
        createSet // createConfig;
    };
  };
}
