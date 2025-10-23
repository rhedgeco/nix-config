{
  lib,
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
