{ lib, ... }: {
  den.aspects.hedgebox.provides.ryan.homeManager = {
    # include all custom niri files by default
    den.niri.include =
      let
        kdlFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".kdl" name) (
          builtins.readDir ./_assets/niri
        );
      in
      lib.mapAttrs' (name: _: {
        name = name;
        value = ./_assets/niri/${name};
      }) kdlFiles;
  };
}
