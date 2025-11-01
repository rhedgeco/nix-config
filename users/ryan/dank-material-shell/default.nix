{
  lib,
  pkgs,
  iglib,
  config,
  inputs,
  ...
}: let
  impermanence = config.custom.impermanence;
in {
  # import the dank material shell home module
  imports = [inputs.dankMaterialShell.homeModules.dankMaterialShell.default];

  # enable dank material shell and launch with systemd
  programs.dankMaterialShell = {
    enable = true;
    enableSystemd = true;
  };

  # create a services that update the clipboard history
  systemd.user.services = {
    update-cliphist-text = iglib.mkDefaultHomeService {
      description = "Updates cliphist with any new text from wl-paste";
      script = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist} store";
      restart = true;
    };
    update-cliphist-image = iglib.mkDefaultHomeService {
      description = "Updates cliphist with any new images from wl-paste";
      script = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist} store";
      restart = true;
    };
  };

  # persist the dms state directory if impermanence is enabled
  # this persists notepad sessions and appusage
  home.persistence = lib.mkIf impermanence.enable {
    "${impermanence.userDir}".directories = [
      ".local/state/DankMaterialShell"
    ];
  };

  # create the dms settings json file
  home.file.".config/DankMaterialShell/settings.json" = {
    text = builtins.readFile ./settings.json;
    force = true;
  };
}
