{...}: {
  den.aspects.niri = {
    provides.to-users.homeManager = {pkgs, ...}: {
      sessions.niri = {
        packages = [pkgs.niri];
      };
    };
  };
}
