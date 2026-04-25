{...}: let
  # define all core linux tools
  # these will exist on every linux system
  linux-tools = pkgs:
    with pkgs; [
      bat
      direnv
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
  # apply core tools to all respective systems
  den.default = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = linux-tools pkgs;
    };
    homeManager = {pkgs, ...}: {
      home.packages = linux-tools pkgs;
    };

    # persist some home files related to the core tools
    persist-home.directories = [
      # persist the direnv cache
      # contains allow list, etc...
      ".local/share/direnv"
    ];
  };
}
