{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  ryan = config.myconfig.users.ryan;
  yoink = inputs.yoink.packages.${pkgs.system}.default;
in {
  options.myconfig.users = {
    ryan.enable = lib.mkEnableOption "Enable ryan user";
  };

  config = lib.mkIf ryan.enable {
    # create the ryan user
    users.users.ryan = {
      isNormalUser = true;
      useDefaultShell = true;
      initialPassword = "ryan";
      extraGroups = ["wheel"];
    };

    # create systemd service that populates all the dotfiles
    systemd.services.yoink-push-ryan = {
      enable = true;
      description = "Manages dotfiles for ryan";

      serviceConfig = {
        User = "ryan";
        Group = "users";
        WorkingDirectory = "/home/ryan";
        ExecStart = "${yoink}/bin/yoink -r ${./yoinkfiles} push";
        StandardOutput = "journal";
        StandardError = "journal";
        Type = "oneshot";
      };

      after = [
        "local-fs.target" # Ensures all local filesystems are mounted.
        "home.mount" # Specifically ensures the /home directory is mounted.
      ];

      wantedBy = ["multi-user.target"];
    };
  };
}
