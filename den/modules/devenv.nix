{
  den.aspects.devenv = {
    homeManager = {pkgs, ...}: {
      home.packages = [pkgs.devenv];
      programs.fish.interactiveShellInit = ''
        ${pkgs.devenv}/bin/devenv hook fish | source
      '';

      persist.directories = [
        # persist the devenv cache
        # contains allow list, etc...
        ".local/share/devenv"
      ];
    };
  };
}
