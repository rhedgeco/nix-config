{
  lib,
  pkgs,
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
  systemd.user.services.discord-runner = {
    Unit.Description = "Launches discord on login";
    Service.ExecStart = "${discord}/bin/discord";
    Install.WantedBy = ["default.target"];
  };

  # create the discord settings json file
  home.file.".config/discord/settings.json" = {
    text = builtins.readFile ./settings.json;
    force = true;
  };
}
