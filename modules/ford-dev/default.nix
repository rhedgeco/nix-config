{
  lib,
  pkgs,
  iglib,
  ...
}: let
  zscaler = pkgs.callPackage ./zscaler.nix {};
in
  iglib.module {
    name = "ford-dev";

    home.enabled = {
      home.packages = [
        zscaler.zsaservice
        zscaler.zstunnel
      ];
    };

    nixos = ctx: {
      always = lib.mkIf ctx.users.anyEnabled {
        # D-Bus policy files so zscaler services can communicate over the system bus
        services.dbus.packages = [zscaler.zscaler-unwrapped];

        # zsaservice - main zscaler monitoring daemon (runs as root)
        systemd.services.zsaservice = {
          description = "Zscaler Service for monitoring Tunnel and Tray";
          after = ["network.target" "dbus.socket"];
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            ExecStart = "${zscaler.zsaservice}/bin/zsaservice";
            KillMode = "process";
            Restart = "always";
            Type = "simple";
            RestartSec = "2s";
            TimeoutStartSec = "5s";
            IgnoreSIGPIPE = "no";
            StandardOutput = "journal";
            StandardError = "inherit";
            RemainAfterExit = true;
          };
        };

        # zstunnel - the tunnel process (runs as root)
        systemd.services.zstunnel = {
          description = "Zscaler ZCC Tunnel process";
          after = ["network.target" "dbus.socket"];
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            ExecStart = "${zscaler.zstunnel}/bin/zstunnel";
            KillMode = "mixed";
            Type = "simple";
            IgnoreSIGPIPE = "no";
            StandardOutput = "journal";
            StandardError = "inherit";
            RemainAfterExit = true;
          };
        };
      };
    };
  }
