let
  defaultFonts = {
    serif = ["Noto Serif Nerd Font"];
    sansSerif = ["Noto Sans Nerd Font"];
    emoji = ["Noto Color Emoji"];
    monospace = ["JetBrains Mono Nerd Font"];
  };
in {
  # include packages needed by default fonts
  den.default = {
    extraFonts = {pkgs, ...}:
      with pkgs; [
        nerd-fonts.noto
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        nerd-fonts.jetbrains-mono
      ];

    nixos.fonts.fontconfig.defaultFonts = defaultFonts;
    homeManager.fonts.fontconfig.defaultFonts = defaultFonts;
  };
}
