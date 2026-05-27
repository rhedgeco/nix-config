{
  den.aspects.glade = {
    provides.to-users.homeManager = {pkgs, ...}: {
      sessions.glade.packages = with pkgs; [
        niri
      ];
    };
  };
}
