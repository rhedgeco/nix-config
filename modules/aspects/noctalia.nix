{ lib, inputs, ... }:
let
  # types that coerce json and toml to attr sets
  tomlBuilder = attrBuilder (s: fromTOML s);
  jsonBuilder = attrBuilder (s: builtins.fromJSON s);
  attrBuilder =
    func:
    lib.types.coercedTo lib.types.path (p: builtins.readFile p) (
      lib.types.coercedTo lib.types.str func lib.types.attrs
    );
in
{
  den.aspects.noctalia.homeManager = { pkgs, config, ... }: {
    options.den.noctalia = {
      includes = lib.mkOption {
        description = "Toml files to apply in order for noctalia settings";
        type = lib.types.listOf tomlBuilder;
        default = [ ];
      };
      settings = lib.mkOption {
        description = "Base settings included at default priority";
        type = tomlBuilder;
        default = { };
      };
      palettes = lib.mkOption {
        description = "Palettes to include with the noctalia install";
        type = lib.types.attrsOf jsonBuilder;
        default = { };
      };
      plugins = lib.mkOption {
        description = "Plugins to include with the noctalia install";
        type = with lib.types; attrsOf path;
        default = { };
      };
    };

    config = {
      home.packages = [
        # include the noctalia package from flake inputs
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      persist.dirs = [
        # only persist the calendar part of the cache
        # so calendar events persist without network
        ".cache/noctalia/calendar"
      ];

      # include the nix noctalia settings with default priority
      den.noctalia.includes = [ config.den.noctalia.settings ];

      den.noctalia.settings = {
        # set plugins to not auto update by default
        plugins.auto_update = "none";
        # enable all the included plugins by default
        plugins.enabled = lib.mapAttrsToList (
          _: path: (lib.importTOML "${path}/plugin.toml").id
        ) config.den.noctalia.plugins;
      };

      home.file = lib.mkMerge [
        # link all the plugin files
        (lib.mapAttrs' (name: path: {
          name = ".local/share/noctalia/plugins/${name}";
          value.source = path;
        }) config.den.noctalia.plugins)

        # link all the color palette files
        (lib.mapAttrs' (name: content: {
          name = ".config/noctalia/palettes/${name}.json";
          value.source = (pkgs.formats.json { }).generate name content;
        }) config.den.noctalia.palettes)

        {
          # link the `.setup-complete` file to silence welcome banner
          ".local/state/noctalia/.setup-complete".text = "";

          # generate and link the main settings.toml file
          ".config/noctalia/settings.toml".text = ''
            [include]
            files = [
              ${lib.concatMapStringsSep "\n  " (
                toml: ''"${(pkgs.formats.toml { }).generate "includes.toml" toml}",''
              ) config.den.noctalia.includes}
            ]
          '';
        }
      ];
    };
  };
}
