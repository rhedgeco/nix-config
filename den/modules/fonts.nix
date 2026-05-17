{lib, ...}: {
  den.default = {
    nixos = {pkgs, ...}: {
      fonts.packages = with pkgs; [
        nerd-fonts.noto
        nerd-fonts.jetbrains-mono
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
      ];

      fonts.fontconfig.defaultFonts = {
        serif = lib.mkDefault ["Noto Serif Nerd Font"];
        sansSerif = lib.mkDefault ["Noto Sans Nerd Font"];
        emoji = lib.mkDefault ["Noto Color Emoji"];
        monospace = lib.mkDefault ["JetBrains Mono Nerd Font"];
      };
    };
  };
}
