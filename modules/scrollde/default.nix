{
  lib,
  pkgs,
  iglib,
  ...
}: let
  # define some shared options that will be used in both nixos and home setups
  outputsOption = lib.mkOption {
    description = "Monitor configuration";
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        mode = lib.mkOption {
          description = "Set the monitor resolution and refresh rate";
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
        scale = lib.mkOption {
          description = "Set the scale of the monitor";
          type = lib.types.nullOr lib.types.float;
          default = null;
        };
      };
    });
    default = {};
  };
in
  iglib.module {
    name = "scrollde";

    nixos = ctx: {
      # use the shared config settings at the nixos level
      options.outputs = outputsOption;

      # apply some nixos settings when scrollde is enabled
      always = {
        igloo.home = {
          # pass through any shared options to all igloo users
          igloo.modules.scrollde.outputs = ctx.module.outputs;
        };
      };
    };

    home = ctx: {
      options = {
        outputs = outputsOption;
        spawn = lib.mkOption {
          description = "Apps to spawn when the environment starts up";
          type = lib.types.listOf lib.types.str;
          default = [];
        };
        binds = lib.mkOption {
          description = "Keybinds that map a key combo to a command";
          type = with lib.types; attrsOf (oneOf [str (listOf str)]);
          default = {};
        };
        niriConfig = lib.mkOption {
          description = "Custom configuration to apply to niri";
          type = with lib.types; oneOf [str path];
          default = "";
        };
      };

      enabled = let
        # define a function for escaping kdl strings
        escapeKdl = str: "\"${lib.replaceStrings ["\\" "\""] ["\\\\" "\\\""] str}\"";

        # define a function for null fallback values
        nullElse = default: item: make:
          if item != null
          then (make item)
          else default;
      in {
        home.packages = [
          # add alacritty since its used as the terminal emulator
          pkgs.alacritty
        ];

        # persist the vicinae directory for now
        # programatic config can be done later
        igloo.modules.persist.dirs = [
          ".local/share/vicinae"
        ];

        # set up niri builtin configuration file
        home.file.".config/scrollde/niri-defaults.kdl" = {
          force = true;
          text = ''
            // include static defaults
            include "${./niri.kdl}"

            // use vicinae as the launcher for this environment
            // the vicinae server has to be spawned at startup
            spawn-sh-at-startup "${pkgs.vicinae}/bin/vicinae server"

            // include some custom nix defined binds
            binds {
              // spawn alacritty as the terminal emulator
              Mod+T { spawn "${pkgs.alacritty}/bin/alacritty"; }

              // use vicinae as the default application launcher
              Mod+Space hotkey-overlay-title="Application Launcher" {
                  spawn "${pkgs.vicinae}/bin/vicinae" "toggle";
              }
            }
          '';
        };

        # set up user generated niri configuration
        # this is split up so that the user can override builtins
        home.file.".config/scrollde/niri.kdl" = {
          force = true;
          text = ''
            // include the default scrollde niri config
            include "./niri-defaults.kdl"

            // set up custom output definitions defined by user and hosts
            ${lib.concatStringsSep "\n" (
              map (set: ''
                output ${escapeKdl set.name} {${lib.concatStrings [
                  (nullElse "" set.value.mode (mode: "\n  mode ${escapeKdl mode}"))
                  (nullElse "" set.value.scale (scale: "\n  scale ${toString scale}"))
                ]}
                }'') (lib.attrsToList ctx.module.outputs)
            )}

            // spawn custom startup apps defined by user
            ${lib.concatStringsSep "\n" (
              map (cmd: "spawn-at-startup ${escapeKdl cmd}") ctx.module.spawn
            )}

            // set up custom key binds defined by users
            binds {
            ${lib.concatStrings (
              map (set: ''
                ''\  ${set.name} { spawn ${lib.concatStringsSep " " (
                  map escapeKdl (
                    if lib.isList set.value
                    then set.value
                    else [set.value]
                  )
                )}; }
              '') (lib.attrsToList ctx.module.binds)
            )}}

            // apply custom niri config last so it can override anything
            include "${
              let
                config = ctx.module.niriConfig;
              in
                if lib.isString config
                then pkgs.writeText "config.kdl" config
                else config
            }";
          '';
        };

        # link to default niri config location for now
        home.file.".config/niri/config.kdl" = {
          force = true;
          text = ''
            include "../scrollde/niri.kdl"
          '';
        };
      };
    };
  }
