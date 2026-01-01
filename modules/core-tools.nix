{
  pkgs,
  iglib,
  inputs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;

  # core fonts to be included on every system
  fontPackages = with pkgs; [
    nerd-fonts.noto
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  # default font names to apply to all font configs
  defaultFonts = {
    serif = ["Noto Serif Nerd Font"];
    sansSerif = ["Noto Sans Nerd Font"];
    emoji = ["Noto Color Emoji"];
    monospace = ["JetBrains Mono Nerd Font"];
  };

  # core cli tools to be included on every system
  cliTools = with pkgs; [
    bat
    vim
    nano
    direnv
    fd
    gum
    inotify-tools
    just
    python3
    (inputs.yoink.packages.${system}.default)
  ];
in
  iglib.module {
    name = "core-tools";
    enabled = true; # enable these tools by default

    # apply all packages at the nixos level
    nixos.enabled = {
      environment.systemPackages = cliTools;
      fonts.packages = fontPackages;
      fonts.fontconfig.defaultFonts = defaultFonts;
    };

    # apply all packages at the home manager level
    home.enabled = {
      home.packages = cliTools ++ fontPackages;
      fonts.fontconfig.defaultFonts = defaultFonts;
    };
  }
