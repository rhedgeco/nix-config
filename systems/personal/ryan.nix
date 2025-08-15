{
  pkgs,
  inputs,
  ...
}: let
  yoink = inputs.yoink.packages.${pkgs.system}.default;
in {
  # set ryan user
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
      ExecStart = "${yoink}/bin/yoink -r ${./.} push";
      StandardOutput = "journal";
      StandardError = "journal";
      Type = "oneshot";
    };

    after = [
      "local-fs.target" # Ensures all local filesystems are mounted.
      "home.mount" # Specifically ensures the /home directory (or equivalent) is mounted.
    ];

    wantedBy = ["multi-user.target"];
  };

  # persist some user directories
  environment.persistence."/persist".users.ryan = {
    directories = [
      # basic user directories
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"

      # ssh and gpg keys
      {
        directory = ".ssh";
        mode = "0700";
      }
      {
        directory = ".gnupg";
        mode = "0700";
      }

      # keyring
      {
        directory = ".local/share/keyrings";
        mode = "0700";
      }
    ];
  };
}
