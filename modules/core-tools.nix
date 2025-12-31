{
  pkgs,
  iglib,
  inputs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
  yoink = inputs.yoink.packages.${system}.default;
  fontSetup = {
    packages = with pkgs; [
      nerd-fonts.noto
      nerd-fonts.jetbrains-mono
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];

    fontconfig.defaultFonts = {
      serif = ["Noto Serif Nerd Font"];
      sansSerif = ["Noto Sans Nerd Font"];
      emoji = ["Noto Color Emoji"];
      monospace = ["JetBrains Mono Nerd Font"];
    };
  };
in
  iglib.module {
    name = "core-tools";
    enabled = true; # enable these tools by default

    nixos.enabled = {
      # set up fonts with nixos
      fonts = fontSetup;
    };

    home.enabled = {
      # set up fonts with home manager
      fonts = fontSetup;
    };

    # tools included with any system by default
    packages = with pkgs; [
      # cli tools
      bat
      vim
      nano
      direnv
      fd
      gum
      inotify-tools
      just
      python3
      yoink
    ];
  }
