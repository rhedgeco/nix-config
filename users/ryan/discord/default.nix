{
  lib,
  pkgs,
  config,
  ...
}: let
  impermanence = config.custom.impermanence;
in {
  home.packages = [
    (pkgs.discord.override {
      withOpenASAR = true;
    })
  ];

  # persist the discord directory if impermanence is enabled
  home.persistence = lib.mkIf impermanence.enable {
    "${impermanence.userDir}".directories = [
      ".config/discord"
    ];
  };

  # create the discord settings json file
  home.file.".config/discord/settings.json" = {
    text = builtins.readFile ./settings.json;
    force = true;
  };
}
