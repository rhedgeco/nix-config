{
  den.aspects.jetpack.provides.ryan.homeManager = {pkgs, ...}: {
    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 22;
    };
  };
}
