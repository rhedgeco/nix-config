{
  den.aspects.direnv = {
    homeManager = {pkgs, ...}: {
      home.packages = [pkgs.direnv];
      programs.fish.interactiveShellInit = ''
        ${pkgs.direnv}/bin/direnv hook fish | source
      '';

      persist.directories = [
        # persist the direnv cache
        # contains allow list, etc...
        ".local/share/direnv"
      ];
    };
  };
}
