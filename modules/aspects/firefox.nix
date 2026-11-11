{
  den.aspects.firefox.homeManager = { pkgs, ... }: {
    # include firefox package
    home.packages = [ pkgs.firefox ];

    # persist the firefox state directory
    persist.dirs = [ ".config/mozilla/firefox" ];

    # enable mime specification
    xdg.mime.enable = true;

    # include firefox in favorites for vicinae
    den.vicinae.settings.favorites = [
      "applications:firefox"
    ];
  };
}
