let
  # fonts that should be available on every system
  mkFonts = pkgs:
    with pkgs; [
      nerd-fonts.noto
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
    ];

  # default font settings for every system
  defaultFonts = {
    serif = ["Noto Serif Nerd Font"];
    sansSerif = ["Noto Sans Nerd Font"];
    emoji = ["Noto Color Emoji"];
    monospace = ["JetBrains Mono Nerd Font"];
  };
in {
  den.default = {
    nixos = {pkgs, ...}: {
      fonts.packages = mkFonts pkgs;
      fonts.fontconfig.defaultFonts = defaultFonts;
    };
    homeManager = {pkgs, ...}: {
      home.packages = mkFonts pkgs;
      fonts.fontconfig.defaultFonts = defaultFonts;
    };
  };
}
