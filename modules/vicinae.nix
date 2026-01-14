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
    };

    enabled = let
      # keyboard interactivity needs to be set to on_demand
      # if close on focus loss is set, otherwise it wont work
      keyboardInteractivity =
        if ctx.module.closeOnFocusLoss
        then "on_demand"
        else "exclusive";

      # create another home config file that uses the settings file as an import
      defaultSettings = pkgs.writeText "settings.json" ''
        {
          "imports": [
            "igloo.json"
          ]
        }
      '';
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
        text = ''
          {
            "close_on_focus_loss": ${lib.boolToString ctx.module.closeOnFocusLoss},
            "pop_to_root_on_close": ${lib.boolToString ctx.module.popToRootOnClose},
            "launcher_window": {
              "layer_shell": {
                "keyboard_interactivity": "${keyboardInteractivity}"
              }
            }
          }
        '';
      };

      # write the default settings file to the correct location
      igloo.create.".config/vicinae/settings.json" = defaultSettings;
    };
  };
}
