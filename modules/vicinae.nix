{
  lib,
  pkgs,
  iglib,
  ...
}:
iglib.module {
  name = "vicinae";

  home = ctx: {
    options = {
      closeOnFocusLoss = lib.mkOption {
        description = "Sets the vicinae window to close itself when focus is lost";
        type = lib.types.bool;
        default = true;
      };
      popToRootOnClose = lib.mkOption {
        description = "Sets the vicinae window start at the root level when the window closes";
        type = lib.types.bool;
        default = false;
      };
      favorites = lib.mkOption {
        description = "Adds strings to the vicinae favorites list";
        type = with lib.types; listOf str;
        default = [];
      };
    };

    enabled = let
      settings = {
        favorites = ctx.module.favorites;
        close_on_focus_loss = ctx.module.closeOnFocusLoss;
        pop_to_root_on_close = ctx.module.popToRootOnClose;
        launcher_window.layer_shell.keyboard_interactivity =
          if ctx.module.closeOnFocusLoss
          then "on_demand"
          else "exclusive";
      };
    in {
      # add the vicinae package
      home.packages = [pkgs.vicinae];

      # persist the vicinae local share for now
      # TODO: add declarative local share content
      igloo.modules.persist.dirs = [
        ".local/share/vicinae"
      ];

      # generate a settings file with all igloo settings in the vicinae directory
      home.file.".config/vicinae/igloo.json" = {
        force = true;
        # this is not necessary, but we use jq here to force a pretty print on the json
        source = pkgs.runCommand "settings.json" {} ''
          echo '${builtins.toJSON settings}' | ${pkgs.jq}/bin/jq '.' > $out
        '';
      };

      # write the default settings file to the correct location
      igloo.create.".config/vicinae/settings.json" = pkgs.writeText "settings.json" ''
        {
          "imports": [
            "igloo.json"
          ]
        }
      '';
    };
  };
}
