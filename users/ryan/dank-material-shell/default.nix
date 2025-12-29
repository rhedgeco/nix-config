{
  pkgs,
  inputs,
  ...
}: {
  # import the dank material shell home module
  imports = [inputs.dankMaterialShell.homeModules.dank-material-shell];

  # enable dank material shell and launch with systemd
  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
  };

  # create a services that update the clipboard history
  systemd.user.services = {
    update-cliphist-text = {
      Unit.Description = "Updates cliphist with any new text from wl-paste";
      Service.ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store";
      Install.WantedBy = ["default.target"];
      Service.Restart = "always";
    };
    update-cliphist-image = {
      Unit.Description = "Updates cliphist with any new images from wl-paste";
      Service.ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store";
      Install.WantedBy = ["default.target"];
      Service.Restart = "always";
    };
  };

  # persist the dms state directory if needed
  # this persists notepad sessions and appusage
  igloo.modules.persist.dirs = [
    ".local/state/DankMaterialShell"
  ];

  # create the dms settings json file
  home.file.".config/DankMaterialShell/settings.json" = {
    text = builtins.readFile ./settings.json;
    force = true;
  };
}
