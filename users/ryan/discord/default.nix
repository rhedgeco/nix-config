{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  impermanence = config.custom.impermanence;
  yoink = inputs.yoink.packages.${pkgs.system}.default;
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

  # run a systemd service that pushes the yoinkfile
  systemd.user.services.push-discord-settings = {
    Unit = {
      Description = "Push discord settings on login";
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
