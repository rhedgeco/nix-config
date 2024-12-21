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
    ensure-persist-config = ''
      if [ ! -d "/persist/nix-config" ]; then
        cp -rf ${../../.} /persist/nix-config
        chown -R root:nixconfig /persist/nix-config
        chmod -R 775 /persist/nix-config

        cd /persist/nix-config
        ${pkgs.git}/bin/git init --initial-branch=main
        ${pkgs.git}/bin/git remote add origin git@github.com:rhedgeco/nix-config.git
      fi
    '';
  };

  # system state
  system.stateVersion = "24.05";
}
