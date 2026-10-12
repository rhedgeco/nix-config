{
  lib,
  mylib,
  inputs,
  ...
}:
{
  den.aspects.noctalia.homeManager = { pkgs, config, ... }: {
    options.den.noctalia = {
      includes = lib.mkOption {
        description = "Toml files to apply in order for noctalia settings";
        type = lib.types.listOf mylib.types.fromToml;
        default = [ ];
      };
      settings = lib.mkOption {
        description = "Base settings included at default priority";
        type = mylib.types.fromToml;
        default = { };
      };
      palettes = lib.mkOption {
        description = "Palettes to include with the noctalia install";
        type = lib.types.attrsOf mylib.types.fromJson;
        default = { };
      };
      plugins.sources = lib.mkOption {
        description = "Plugin data to include with the noctalia install";
        type = with lib.types; attrsOf path;
        default = { };
      };
      plugins.official = lib.mkOption {
        description = "Official plugins to include with the noctalia install";
        type = with lib.types; listOf str;
        default = [ ];
      };
      plugins.community = lib.mkOption {
        description = "Community plugins to include with the noctalia install";
        type = with lib.types; listOf str;
        default = [ ];
      };
      extraPackages = lib.mkOption {
        description = "Packages to make available to the noctalia shell";
        type = with lib.types; listOf package;
        default = [ ];
      };
    };

    config = {
      home.packages = [
        (pkgs.symlinkJoin {
          name = "noctalia-wrapped";
          paths = [ inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/noctalia \
              --prefix PATH : ${lib.makeBinPath config.den.noctalia.extraPackages}
          '';
        })
      ];

      persist.dirs = [
        # only persist the calendar part of the cache
        # so calendar events persist without network
        ".cache/noctalia/calendar"
      ];

      # include the nix noctalia settings with default priority
      den.noctalia.includes = [ config.den.noctalia.settings ];

      # pull the official and community plugins from the repo
      # apply the plugin sources from the repo to the plugins.sources list
      den.noctalia.plugins.sources = builtins.listToAttrs (
        (map (name: {
          inherit name;
          value = inputs.noctalia-plugins-official + "/${name}";
        }) config.den.noctalia.plugins.official)
        ++ (map (name: {
          inherit name;
          value = inputs.noctalia-plugins-community + "/${name}";
        }) config.den.noctalia.plugins.community)
      );

      den.noctalia.settings = {
        # set plugins to not auto update by default
        plugins.auto_update = "none";
        # enable all the included plugins by default
        plugins.enabled = lib.mapAttrsToList (
          _: path: (lib.importTOML "${path}/plugin.toml").id
        ) config.den.noctalia.plugins.sources;
      };

      home.file = lib.mkMerge [
        # link the `.setup-complete` file to silence welcome banner
        { ".local/state/noctalia/.setup-complete".text = ""; }

        # link all the plugin files
        (lib.mapAttrs' (name: path: {
          name = ".local/share/noctalia/plugins/${name}";
          value.source = path;
        }) config.den.noctalia.plugins.sources)

        # link all the color palette files
        (lib.mapAttrs' (name: content: {
          name = ".config/noctalia/palettes/${name}.json";
          value.source = (pkgs.formats.json { }).generate name content;
        }) config.den.noctalia.palettes)

        {
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
