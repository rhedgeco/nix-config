{
  lib,
  config,
  inputs,
  ...
}: let
  impermanence = config.myconfig.impermanence;
in {
  # import caelestia-shell home manager module
  imports = [inputs.caelestia-shell.homeManagerModules.default];

  # persist caelestia-shell state if impermanence is enabled
  home.persistence = lib.mkIf impermanence.enable {
    "${impermanence.userDir}" = {
      allowOther = true;
      directories = [
        ".local/state/caelestia"
      ];
    };
  };

  # enable and configure caelestia
  programs.caelestia = {
    enable = true;
    systemd = {
      target = "graphical-session.target";
      environment = [];
    };
    settings = {
      paths.wallpaperDir = "~/Pictures/wallpapers";
      bar.entries = [
        {
          "id" = "logo";
          "enabled" = true;
        }
        {
          "id" = "spacer";
          "enabled" = true;
        }
        {
          "id" = "clock";
          "enabled" = true;
        }
        {
          "id" = "statusIcons";
          "enabled" = true;
        }
        {
          "id" = "power";
          "enabled" = true;
        }
      ];
    };
    cli = {
      enable = true; # Also add caelestia-cli to path
      settings = {
        theme.enableGtk = false;
      };
    };
  };
}
