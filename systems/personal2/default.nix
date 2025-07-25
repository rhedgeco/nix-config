{inputs, ...}: {
  imports = [
    # import home manager module
    inputs.home-manager.nixosModules.home-manager

    # import impermanence module
    inputs.impermanence.nixosModules.impermanence

    # import local folder modules
    ./grub

    # import all other local modules
    ./code.nix
    ./docker.nix
    ./firefox.nix
    ./gui.nix
    ./mime.nix
    ./network.nix
    ./shell.nix
    ./users.nix
  ];

  # enable flakes
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };

  # allow non root users to fuse mount
  programs.fuse.userAllowOther = true;

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # set up home manager
  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs;};
  };

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
    ];
  };

  # initial state version (do not change)
  system.stateVersion = "24.05";
}
