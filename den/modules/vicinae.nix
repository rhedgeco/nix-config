{
  den.aspects.vicinae = {
    homeManager = {
      lib,
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

        # persist the vicinae local share for now
        # TODO: add declarative local share content
        persist.directories = [
          ".local/share/vicinae"
        ];

        # scribe the vicinae settings file
        scribe.".config/vicinae/settings.json" = let
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
          # not necessary, but we use jq here to pretty print the json
          # it makes it easier for a human to read their settings file
          pkgs.runCommand "vicinae-settings.json" {} ''
            echo '${builtins.toJSON settings}' | ${pkgs.jq}/bin/jq '.' > $out
          '';
      };
    };
  };
}
