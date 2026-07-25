let
  mkFonts = pkgs:
    with pkgs; [
      nerd-fonts.noto
      nerd-fonts.jetbrains-mono
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];

  defaultFonts = {
    serif = ["Noto Serif Nerd Font"];
    sansSerif = ["Noto Sans Nerd Font"];
    emoji = ["Noto Color Emoji"];
    monospace = ["JetBrains Mono Nerd Font"];
  };

  mkTools = pkgs:
    with pkgs; [
      bat
      vim
      nano
      direnv
      fd
      iw
      jq
      gum
      tree
      inotify-tools
      just
      python3
      pciutils
      ffmpeg
      gnome-disk-utility
    ];
in {
  den.default = {
    # apply all packages and fonts at the nixos level
    nixos = {pkgs, ...}: {
      environment.systemPackages = mkTools pkgs;
      fonts.packages = mkFonts pkgs;
      fonts.fontconfig.defaultFonts = defaultFonts;
    };

    # apply all packages and fonts to each nixos user
    # this help apply the core tools to standalone homes too
    homeManager = {pkgs, ...}: {
      home.packages = (mkTools pkgs) ++ (mkFonts pkgs);
    };
  };
}
