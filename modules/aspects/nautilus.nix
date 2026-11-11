{
  den.aspects.nautilus.homeManager = { pkgs, ... }: {
    # include nautilus package
    home.packages = [ pkgs.nautilus ];

    # include nautilus in favorites for vicinae
    den.vicinae.settings.favorites = [
      "applications:org.gnome.Nautilus"
    ];
  };
}
