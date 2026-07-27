{
  den.aspects.steam = {
    nixos.programs.steam.enable = true;
    homeManager.persist.dirs = [
      ".local/share/Steam"
      ".steam"
    ];
  };
}
