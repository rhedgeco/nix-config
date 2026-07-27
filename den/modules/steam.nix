{
  den.aspects.steam = {
    homeManager.persist.dirs = [
      ".local/share/Steam"
      ".steam"
    ];

    # steam has to be enabled at the nixos level
    provides.to-hosts.nixos = {
      programs.steam.enable = true;
    };
  };
}
