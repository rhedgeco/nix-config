{...}: let
  cliTools = pkgs:
    with pkgs; [
      bat
      vim
      nano
      fd
      gum
      tree
      inotify-tools
      just
      python3
      pciutils
      ffmpeg
    ];
in {
  den.default = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = cliTools pkgs;
    };

    homeManager = {pkgs, ...}: {
      home.packages = cliTools pkgs;
    };
  };
}
