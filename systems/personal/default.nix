{pkgs, ...}: {
  # import all packages and users
  imports = [
    ./modules
    ./users
  ];

  # system stuff
  xdg.mime.enable = true;
  networking.networkmanager.enable = true;
  programs.fuse.userAllowOther = true;
  nixpkgs.config.allowUnfree = true;
  services.printing.enable = true;
  programs.dconf.enable = true;

  # enable flakes
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };

  # persist some system directories
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/alsa"
      "/var/lib/bluetooth"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];
  };

  system.activationScripts = {
    # make sure that the configuration is always in the persist directory
    ensure-persist-config = ''
      echo "ensuring /persist/nix-config exists..."
      if [ ! -d "/persist/nix-config" ]; then
        echo "/persist/nix-config not found, copying from store..."
        cp -rf ${../../.} /persist/nix-config
      fi

      echo "ensuring correct permissions for config files..."
      chgrp -R nixconfig /persist/nix-config
      find /persist/nix-config -type d -exec chmod ug+rws {} \;
      find /persist/nix-config -type f -exec chmod ug+rw {} \;
      find /persist/nix-config -type d -exec ${pkgs.acl}/bin/setfacl -m "default:user::rwx" {} +
      find /persist/nix-config -type d -exec ${pkgs.acl}/bin/setfacl -m "default:group::rwx" {} +
    '';
  };

  # system state
  system.stateVersion = "24.05";
}
