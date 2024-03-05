{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./persist.nix
  ];

  # system stuff
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;
  programs.fuse.userAllowOther = true;
  services.printing.enable = true;
  programs.dconf.enable = true;

  # enable flakes
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };

  # use gdm and gnome
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.excludePackages = [pkgs.xterm];
  services.gnome.core-utilities.enable = false;
  environment.gnome.excludePackages = with pkgs; [
    gnome.gnome-shell-extensions
    gnome-tour
  ];

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # add essential system packages
  environment.systemPackages = with pkgs;
    [
      vim
      wget
      curl
      just
      pciutils
      inotify-tools
      firefox

      # add some gnome apps
      gnome.gnome-tweaks
      gnome.gnome-terminal
      gnome.gnome-calculator
      gnome.gnome-screenshot
      gnome.gnome-system-monitor
      gnome.nautilus # files
      gnome.gedit # text editor
      gnome.baobab # disk usage analyzer
      loupe # image viewer
    ]
    ++ [
      # add home manager binary
      inputs.home-manager.packages.${pkgs.system}.default
    ];

  # set up git with lfs
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  # set up system fonts
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      jetbrains-mono
    ];

    fontconfig.defaultFonts = {
      serif = ["Noto Serif"];
      sansSerif = ["Noto Sans"];
      emoji = ["Noto Color Emoji"];
      monospace = ["JetBrains Mono"];
    };
  };

  # configure default shell with zsh
  users.defaultUserShell = pkgs.zsh;
  environment = {
    shells = with pkgs; [zsh];
    variables.EDITOR = "vim";
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      theme = "lukerandall";
    };
  };

  users.users = {
    ryan = {
      isNormalUser = true;
      useDefaultShell = true;
      initialPassword = "ryan";
      extraGroups = ["wheel" "networkmanager"];
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      ryan = import ../ryan/home.nix;
    };
  };

  system.stateVersion = "23.11"; # dont touch
}
