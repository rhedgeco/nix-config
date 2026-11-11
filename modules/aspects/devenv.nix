{
  den.aspects.devenv.homeManager = { pkgs, ... }: {
    # persist the devenv cache
    # contains allow list, etc...
    persist.dirs = [ ".local/share/devenv" ];
    home.packages = [ pkgs.devenv ];
  };
}
