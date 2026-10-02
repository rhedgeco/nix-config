{ ... }: {
  den.aspects.jetpack.provides.ryan.homeManager = { ... }: {
    # write the mimeapps file
    den.create.".config/mimeapps.list" = ./_assets/mime/mimeapps.list;

    # write the noctalia settings configuration
    den.create.".config/noctalia/settings.toml" = ./_assets/noctalia/settings.toml;
    den.create.".config/noctalia/palettes/Cream.json" = ./_assets/noctalia/Cream.json;
    den.create.".local/share/noctalia/plugins" = ./_assets/noctalia/plugins;
  };
}
