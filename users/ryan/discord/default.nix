{
  lib,
  pkgs,
  iglib,
  config,
  ...
}: let
  impermanence = config.custom.impermanence;
  discord = pkgs.discord.override {
    withOpenASAR = true;
  };
in {
  home.packages = [discord];

  # persist the discord directory if impermanence is enabled
  home.persistence = lib.mkIf impermanence.enable {
    "${impermanence.userDir}".directories = [
      ".config/discord"
    ];
  };

  # create a systemd service that launches discord when the user logs in
  systemd.user.services.discord-runner = iglib.mkDefaultHomeService {
    description = "Launches discord on login";
    script = "${discord}/bin/discord";
  };

  # create the discord settings json file
  home.file.".config/discord/settings.json" = {
    text = builtins.readFile ./settings.json;
    force = true;
  };
}
