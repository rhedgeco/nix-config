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

      always = {
        # and pass through any shared options to all igloo users
        igloo.home = {
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
      };

      enabled = let
        # define a function for escaping kdl strings
        escapeKdl = str: "\"${lib.replaceStrings ["\\" "\""] ["\\\\" "\\\""] str}\"";

        # define a function for null fallback values
        nullElse = default: item: make:
          if item != null
          then (make item)
          else default;

        niriConfig = ''
          // include all the defaults for scrollde
          include "${./niri.kdl}"

          // custom startup apps defined in nix
          ${lib.concatStringsSep "\n" (
            map (cmd: "spawn-at-startup ${escapeKdl cmd}") ctx.module.spawn
          )}

          // custom output definitions defined in nix
          ${lib.concatStrings (
            map (set: ''
              output ${escapeKdl set.name} {${lib.concatStrings [
                (nullElse "" set.value.mode (mode: "\n  mode ${escapeKdl mode}"))
                (nullElse "" set.value.scale (scale: "\n  scale ${toString scale}"))
              ]}
              }
            '') (lib.attrsToList ctx.module.outputs)
          )}

          // custom key binds defined in nix
          binds {
            // spawn alacritty as the terminal emulator
            Mod+T { spawn "${pkgs.alacritty}/bin/alacritty"; }

            // spawn rofi as the application launcher
            Mod+Space hotkey-overlay-title="Application Launcher" {
                spawn "${pkgs.rofi}/bin/rofi" "-show" "combi" "-combi-modes" "drun,window" "-config" "${./rofi.rasi}";
            }
          }
        '';
      in {
        home.packages = [
          # add alacritty since its used as the terminal emulator
          pkgs.alacritty
        ];

        # set up and link niri config
        home.file.".config/niri/config.kdl" = {
          force = true;
          text = niriConfig;
        };
      };
    };
  }
