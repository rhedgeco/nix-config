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
    name = "niri";

    nixos = ctx: {
      # use the shared config settings at the nixos level
      options.outputs = outputsOption;

      # apply some nixos settings when scrollde is enabled
      always = {
        igloo.home = {
          # pass through any shared options to all igloo users
          igloo.modules.niri.outputs = ctx.module.outputs;
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
        spawnSh = lib.mkOption {
          description = "Shell commands to run when the environment starts up";
          type = lib.types.listOf lib.types.str;
          default = [];
        };
        float = lib.mkOption {
          description = "Apps to set as floating by default";
          type = with lib.types; listOf str;
          default = [];
        };
        binds = lib.mkOption {
          description = "Keybinds that map a key combo to a command";
          type = with lib.types; attrsOf (oneOf [str (listOf str)]);
          default = {};
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

        # create a default configuration for niri
        niriDefaultConfig = pkgs.writeText "niri-default.kdl" ''
          // include static defaults
          include "${./niri-static.kdl}"

          // include some custom nix defined binds
          binds {
            // spawn alacritty as the terminal emulator
            Mod+T { spawn "${pkgs.alacritty}/bin/alacritty"; }
          }
        '';

        niriUserConfig = pkgs.writeText "niri-user.kdl" ''
          // include the default scrollde niri config
          // anything in the default config can be overriden
          include "${niriDefaultConfig}"

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

          // spawn custom startup commands defined by user
          ${lib.concatStringsSep "\n" (
            map (cmd: "spawn-sh-at-startup ${escapeKdl cmd}") ctx.module.spawnSh
          )}

          // set up floating window definitions
          window-rule {
            open-floating true
          ${lib.concatStringsSep "\n" (
            map (appId: "  match app-id=${escapeKdl appId}") ctx.module.float
          )}
          }

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
        '';
      in {
        home.packages = [
          # add alacritty since its used as the terminal emulator
          pkgs.alacritty
        ];

        # link to default niri config location for now
        home.file.".config/niri/config.kdl" = {
          force = true;
          text = ''
            include "${niriUserConfig}"
          '';
        };

        # create the kdl file instead of linking
        # this allows external config changes from other sources
        igloo.create.".config/niri/config.kdl" = pkgs.writeText "config.kdl" ''
          include "${niriUserConfig}"
        '';
      };
    };
  }
