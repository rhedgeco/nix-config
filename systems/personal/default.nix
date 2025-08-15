{inputs, ...}: {
  imports = [
    # import impermanence module
    inputs.impermanence.nixosModules.impermanence

    # import local folder modules
    ./code
    ./grub
    ./niri

    # import all other local modules
    ./docker.nix
    ./embedded.nix
    ./firefox.nix
    ./fonts.nix
    ./greetd.nix
    ./nautilus.nix
    ./network.nix
    ./rust.nix
    ./ryan.nix
    ./shell.nix
  ];

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # enable flakes
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };

  # allow non root users to fuse mount
  programs.fuse.userAllowOther = true;

  # persist some system directories
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      # persist system log files
      "/var/log"

      # needed for nixos systems
      "/var/lib/nixos"

      # bluetooth connection and configuration data
      "/var/lib/bluetooth"

      # systemd coredump info
      "/var/lib/systemd/coredump"

      # persist power profile state
      "/var/lib/power-profiles-daemon"
    ];
  };

  # initial state version (do not change)
  system.stateVersion = "24.05";
}
