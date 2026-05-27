{...}: {
  den.aspects.niri = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = [pkgs.niri];
    };

    provides.to-users.homeManager = {pkgs, ...}: {
      sessions.niri = {
        packages = [pkgs.niri];
      };
    };
  };
}
