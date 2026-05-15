{lib, ...}: let
  # core fonts to be included on every system
  fontPackages = pkgs:
    with pkgs; [
      nerd-fonts.noto
      nerd-fonts.jetbrains-mono
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];

  # default font names to apply to all font configs
  defaultFonts = {
    serif = lib.mkDefault ["Noto Serif Nerd Font"];
    sansSerif = lib.mkDefault ["Noto Sans Nerd Font"];
    emoji = lib.mkDefault ["Noto Color Emoji"];
    monospace = lib.mkDefault ["JetBrains Mono Nerd Font"];
  };
in {
  den.default = {
    nixos = {pkgs, ...}: {
      fonts.packages = fontPackages pkgs;
      fonts.fontconfig.defaultFonts = defaultFonts;
    };

    homeManager = {pkgs, ...}: {
      home.packages = fontPackages pkgs;
      fonts.fontconfig.defaultFonts = defaultFonts;
    };
  };
}
