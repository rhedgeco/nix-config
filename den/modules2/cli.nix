{...}: let
  cliTools = pkgs:
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
      environment.systemPackages = cliTools pkgs;
    };

    homeManager = {pkgs, ...}: {
      home.packages = cliTools pkgs;
    };
  };
}
