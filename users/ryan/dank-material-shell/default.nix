{
  pkgs,
  inputs,
  ...
}: let
  yoink = inputs.yoink.packages.${pkgs.system}.default;
in {
  # import the dank material shell home module
  imports = [inputs.dankMaterialShell.homeModules.dankMaterialShell.default];

  # enable dank material shell and launch with systemd
  programs.dankMaterialShell = {
    enable = true;
    enableSystemd = true;
  };

  # run a systemd service that pushes the yoinkfile
  systemd.user.services.push-dms-settings = {
    Unit = {
      Description = "Push dms settings on login";
      Before = ["graphical-session.target"];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${yoink}/bin/yoink ${./.} push";
    };

    Install = {
      # 'graphical-session-pre.target' is a special target for tasks
      # that must run before the main user session starts up.
      WantedBy = ["graphical-session-pre.target"];
    };
  };
}
