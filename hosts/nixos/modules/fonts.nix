{pkgs, ...}: {
  fonts = {
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
}
