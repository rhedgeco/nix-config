{
  pkgs,
  inputs,
  ...
}: let
  noctalia = inputs.noctalia;
  noctalia-pkg = noctalia.packages.${pkgs.system}.default;
in {
  # import noctalia home manager module
  imports = [noctalia.homeModules.default];

  # include noctalia package with system
  home.packages = [noctalia-pkg];

  # enable the noctalia systemd service
  systemd.user.services.noctalia-shell = {
    Unit = {
      Description = "Noctalia Shell Service";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
    };

    Service = {
      ExecStart = "${noctalia-pkg}/bin/noctalia-shell";
      Restart = "on-failure";
      RestartSec = 1;
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  # configure noctalia for this user
  programs.noctalia-shell = {
    enable = true;
    settings = {
      wallpaper.enabled = false;
      colorSchemes = {
        predefinedScheme = "Ayu";
      };
      general = {
        dimDesktop = false;
        animationSpeed = 2;
        showScreenCorners = true;
        forceBlackScreenCorners = true;
      };
      ui = {
        fontDefault = "Noto Sans Nerd Font";
        fontFixed = "JetBrains Mono Nerd Font";
      };
      notifications = {
        location = "top_center";
        alwaysOnTop = true;
        lowUrgencyDuration = 2;
        normalUrgencyDuration = 3;
        criticalUrgencyDuration = 8;
      };
      controlCenter = {
        cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "audio-card";
          }
          {
            enabled = true;
            id = "media-sysmon-card";
          }
        ];
      };
      bar = {
        floating = true;
        showCapsule = true;
        backgroundOpacity = 0.5;
        widgets = {
          left = [
            {
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "none";
            }
          ];
          center = [
            {
              id = "SystemMonitor";
            }
            {
              id = "Clock";
              formatHorizontal = "ddd - MMM d - HH:mm:ss";
            }
          ];
          right = [
            {
              id = "NightLight";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "WiFi";
            }
            {
              alwaysShowPercentage = false;
              id = "Battery";
              warningThreshold = 30;
            }
            {
              id = "PowerProfile";
            }
            {
              id = "SidePanelToggle";
              useDistroLogo = true;
            }
          ];
        };
      };
    };
  };
}
