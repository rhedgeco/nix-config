{ lib, ... }: {
  den.aspects.vicinae = {
    homeManager =
      {
        pkgs,
        config,
        ...
      }:
      {
        options.den.vicinae = {
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
            default = [ ];
          };
          opacity = lib.mkOption {
            description = "Sets the vicinae window opacity";
            type = lib.types.float;
            default = 1.0;
          };
        };

        config = {
          home.packages = [ pkgs.vicinae ];

          persist.dirs = [
            # TODO: declaratively store vicinae extensions etc...
            ".local/share/vicinae"
          ];

          den.create.".config/vicinae/nix-settings.json" =
            let
              settings = {
                favorites = config.den.vicinae.favorites;
                launcher_window.opacity = config.den.vicinae.opacity;
                close_on_focus_loss = config.den.vicinae.closeOnFocusLoss;
                pop_to_root_on_close = config.den.vicinae.popToRootOnClose;
                launcher_window.layer_shell.keyboard_interactivity =
                  if config.den.vicinae.closeOnFocusLoss then "on_demand" else "exclusive";
              };
            in
            pkgs.runCommand "nix-settings.json" { } ''
              echo '${builtins.toJSON settings}' | ${pkgs.jq}/bin/jq '.' > $out
            '';

          den.create.".config/vicinae/settings.json" = ''
            {
              "imports": [
                "nix-settings.json"
              ]
            }
          '';
        };
      };
  };
}
