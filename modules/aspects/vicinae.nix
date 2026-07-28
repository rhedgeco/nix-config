{lib, ...}: {
  den.aspects.vicinae = {
    homeManager = {
      pkgs,
      config,
      ...
    }: {
      options.vicinae = {
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

      config = {
        home.packages = [pkgs.vicinae];

        persist.dirs = [
          # TODO: declaratively store vicinae extensions etc...
          ".local/share/vicinae"
        ];

        create.".config/vicinae/nix-settings.json" = let
          settings = {
            favorites = config.vicinae.favorites;
            close_on_focus_loss = config.vicinae.closeOnFocusLoss;
            pop_to_root_on_close = config.vicinae.popToRootOnClose;
            launcher_window.layer_shell.keyboard_interactivity =
              if config.vicinae.closeOnFocusLoss
              then "on_demand"
              else "exclusive";
          };
        in
          pkgs.runCommand "nix-settings.json" {} ''
            echo '${builtins.toJSON settings}' | ${pkgs.jq}/bin/jq '.' > $out
          '';

        create.".config/vicinae/settings.json" = ''
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
