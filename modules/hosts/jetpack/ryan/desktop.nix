{ lib, ... }: {
  den.aspects.jetpack.provides.ryan.homeManager = { ... }: {
    den.noctalia.includes = lib.mkAfter [ ./_assets/noctalia.toml ];
    den.niri.includes = lib.mkAfter [ ./_assets/niri.kdl ];
    den.create.".config/mimeapps.list" = ./_assets/mime/mimeapps.list;
  };
}
