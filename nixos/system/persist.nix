{inputs, ...}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];

    users.ryan = {
      directories = [
        "dotfiles"
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        ".mozilla"
        ".gnupg"
        ".ssh"
        ".local/share/keyrings"
      ];
      files = [
        # keep monitor configs
        ".config/monitors.xml"
      ];
    };
  };
}
