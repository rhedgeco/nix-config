{den, ...}: {
  den.aspects.steam = {
    nixos.programs.steam.enable = true;
    provides.to-users.homeManager.persist.dirs = [
      ".local/share/Steam"
      ".steam"
    ];
  };

  den.aspects.jetpack.includes = [
    # den.aspects.steam
  ];
}
