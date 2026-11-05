{
  den.aspects.steam = {
    # enable steam at the nixos level
    nixos.programs.steam.enable = true;

    provides.to-users.homeManager = {
      # persist some user directories
      persist.dirs = [
        ".local/share/Steam"
        ".steam"
      ];

      # add to vicinae favorites if used
      den.vicinae.settings.favorites = [
        "applications:steam"
      ];
    };
  };
}
