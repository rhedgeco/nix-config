{...}: {
  den.aspects.direnv = {
    persist-home.directories = [
      # persist the direnv cache
      # contains allow list, etc...
      ".local/share/direnv"
    ];

    homeManager = {pkgs, ...}: {
      home.packages = [pkgs.direnv];
    };
  };
}
