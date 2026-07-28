{
  den.aspects.direnv.homeManager = {pkgs, ...}: {
    # persist the direnv cache
    # contains allow list, etc...
    persist.dirs = [".local/share/direnv"];
    home.packages = [pkgs.direnv];
    programs.fish.interactiveShellInit = ''
      # load direnv shell hook
      ${pkgs.direnv}/bin/direnv hook fish | source
    '';
  };
}
