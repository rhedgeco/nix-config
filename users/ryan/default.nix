{
  pkgs,
  inputs,
  ...
}: let
  yoink = inputs.yoink.packages.${pkgs.system}.default;
  yoink-push = pkgs.writeShellScript "yoink-push" ''
    ${yoink}/bin/yoink -r ${./yoinkfiles} push
  '';
in {
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  programs.caelestia = {
    enable = true;
    systemd = {
      target = "graphical-session.target";
      environment = [];
    };
    settings = {
      paths.wallpaperDir = "~/Pictures/wallpapers";
    };
    cli = {
      enable = true; # Also add caelestia-cli to path
      settings = {
        theme.enableGtk = false;
      };
    };
  };

  systemd.user.services.yoinkfile-push = {
    Unit = {
      Description = "Pushes yoinkfiles at login";
      Before = ["graphical-session.target"];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${yoink-push}";
    };

    Install = {
      # 'graphical-session-pre.target' is a special target for tasks
      # that must run before the main user session starts up.
      WantedBy = ["graphical-session-pre.target"];
    };
  };
}
