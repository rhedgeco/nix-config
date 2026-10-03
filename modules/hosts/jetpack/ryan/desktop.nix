{ ... }: {
  den.aspects.jetpack.provides.ryan.homeManager = { ... }: {
    den.niri.includes."user-config.kdl" = ./_assets/niri.kdl;
    den.noctalia.config."user-settings.toml" = ./_assets/noctalia.toml;
    den.create.".config/mimeapps.list" = ./_assets/mime/mimeapps.list;
  };
}
