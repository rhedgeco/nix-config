{
  lib,
  mylib,
  inputs,
  ...
}:
{
  # set up vicinae options to always exist
  den.default.homeManager.options.den.vicinae = {
    imports = lib.mkOption {
      description = "Json files to import into vicinae settings";
      type = lib.types.listOf mylib.types.fromToml;
      default = [ ];
    };
    settings = lib.mkOption {
      description = "Base settings included at default priority";
      type = mylib.types.fromJson;
      default = { };
    };
    extensions.sources = lib.mkOption {
      description = "Raw extension data to install to the vicinae extension directory";
      type = with lib.types; attrsOf path;
      default = { };
    };
    extensions.vicinae-store = lib.mkOption {
      description = "Extensions to include from the vicinae store";
      type = with lib.types; listOf str;
      default = [ ];
    };
  };

  # configure vicinae when the aspect is included
  den.aspects.vicinae = {
    homeManager =
      {
        pkgs,
        config,
        ...
      }:
      {
        # include the vicinae package
        home.packages = [ pkgs.vicinae ];

        # always include the nix extension
        den.vicinae.extensions.vicinae-store = [ "nix" ];

        # import the user settings
        den.vicinae.imports = [ config.den.vicinae.settings ];

        # generate the vicinae settings.json so it can be modified
        den.create.".config/vicinae/settings.json" = builtins.toJSON {
          imports = map (
            json: (pkgs.formats.json { }).generate "nix-settings.json" json
          ) config.den.vicinae.imports;
        };

        # apply some default settings
        den.vicinae.settings = {
          close_on_focus_loss = lib.mkDefault true;
          launcher_window.layer_shell.keyboard_interactivity = lib.mkDefault "on_demand";
          pop_to_root_on_close = lib.mkDefault false;
        };

        # persist relevant files
        persist.files = [
          # core state db: root items, aliases, preferences, enabled extensions
          ".local/share/vicinae/vicinae.db"

          # clipboard history
          ".local/share/vicinae/clipboard.db"

          # per-item visit counts / recency that power result ranking
          ".local/share/vicinae/metadata.json"
        ];

        persist.dirs = [
          # user-created snippets
          ".local/share/vicinae/snippets"

          # user-created shortcuts
          ".local/share/vicinae/shortcuts"

          # clipboard history payloads (referenced by clipboard.db)
          ".local/share/vicinae/clipboard-data"

          # persist the state directory
          # holds some useless data, but prevents onboarding popup
          ".local/state/vicinae"

          # persist the file index because its expensive to calculate
          # this prevents indexing every time the computer turns on
          ".cache/vicinae/file-indexer"
        ];

        # link all the extension sources
        home.file = lib.mkMerge [
          (lib.mapAttrs' (name: path: {
            name = ".local/share/vicinae/extensions/${name}";
            value.source = path;
          }) config.den.vicinae.extensions.sources)
        ];

        # map the requested store extension names to their built derivations
        den.vicinae.extensions.sources = builtins.listToAttrs (
          map (
            name:
            let
              # The upstream source as shipped in the extensions repo.
              rawSrc = "${inputs.vicinae-extensions}/extensions/${name}";
              # Some extensions (e.g. bluetooth, systemd) depend on `dbus-next`,
              # which lists `usocket` as an *optional* native dependency.
              # `usocket` requires node-gyp to compile a native addon,
              # which fails in the nix build sandbox.
              # `dbus-next` falls back to node's built-in sockets when `usocket` is absent,
              # and esbuild only bundles what's imported,
              # so we strip `usocket` from the lockfile/manifest before resolving deps.
              src = pkgs.runCommand "vicinae-extension-${name}-src" { } ''
                cp -r ${rawSrc} $out
                chmod -R u+w $out
                if [ -f $out/package-lock.json ]; then
                  ${lib.getExe pkgs.jq} 'del(.packages["node_modules/usocket"])
                    | (.packages[]?.optionalDependencies.usocket) |= empty' \
                    $out/package-lock.json > $out/package-lock.json.tmp
                  mv $out/package-lock.json.tmp $out/package-lock.json
                fi
                if [ -f $out/package.json ]; then
                  ${lib.getExe pkgs.jq} 'del(.optionalDependencies.usocket)' \
                    $out/package.json > $out/package.json.tmp
                  mv $out/package.json.tmp $out/package.json
                fi
              '';
            in
            {
              name = "store.vicinae.${name}";
              value = pkgs.buildNpmPackage {
                pname = name;
                version = "0";
                inherit src;
                npmDeps = pkgs.importNpmLock {
                  npmRoot = src;
                };
                npmConfigHook = pkgs.importNpmLock.npmConfigHook;
                dontNpmInstall = true;
                buildPhase = ''
                  runHook preBuild
                  npm run build -- --out=$out
                  runHook postBuild
                '';
              };
            }
          ) config.den.vicinae.extensions.vicinae-store
        );
      };
  };
}
