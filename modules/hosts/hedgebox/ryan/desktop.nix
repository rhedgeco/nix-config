{ lib, ... }: {
  den.aspects.hedgebox.provides.ryan.homeManager = { ... }: {
    den.noctalia.includes = lib.mkAfter [ ./_assets/noctalia.toml ];
    den.niri.includes."user-config.kdl" = ./_assets/niri.kdl;
    den.create.".config/mimeapps.list" = ./_assets/mime/mimeapps.list;
  };
}
