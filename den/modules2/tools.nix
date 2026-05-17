{...}: let
  mkTools = pkgs:
    with pkgs; [
      bat
      fd
      ffmpeg
      gum
      inotify-tools
      just
      nano
      pciutils
      python3
      tree
      vim
    ];
in {
  den.default = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = mkTools pkgs;
    };

    homeManager = {pkgs, ...}: {
      home.packages = mkTools pkgs;
    };
  };
}
