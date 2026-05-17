{
  den.aspects.steam = {
    # steam has to be enabled at the system level
    nixos = {
      programs.steam = {
        enable = true;
      };
    };

    # but users should have their local steam config persisted
    provides.to-users.homeManager = {
      persist.directories = [
        ".local/share/Steam"
        ".steam"
      ];
    };
  };
}
