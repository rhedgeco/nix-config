{ lib, mylib, ... }: {
  den.aspects.zed.homeManager = { pkgs, config, ... }: {
    options.den.zed = {
      settings = lib.mkOption {
        description = "Zed settings";
        type = mylib.types.fromJson;
        default = { };
      };
    };

    config = {
      home.packages = with pkgs; [
        # include the main editor
        zed-editor

        # include supporting packages for editing nix
        nixd
        nil
      ];

      persist.dirs = [
        # persist zed local share for now
        # TODO: add declarative local share content
        ".local/share/zed"

        # persist copilot authorization
        ".config/github-copilot"
      ];

      # use the dark modern theme by default
      home.file.".config/zed/themes/DarkModern.json".source = ./_assets/zed/DarkModern.json;
      den.zed.settings.theme = "DarkModern";

      # write the zed settings to a file
      # keep this writable so the zed settings gui is usable
      den.create.".config/zed/settings.json" =
        (pkgs.formats.json { }).generate "settings.json"
          config.den.zed.settings;
    };
  };
}
