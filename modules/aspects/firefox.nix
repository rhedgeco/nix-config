{
  den.aspects.firefox.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.firefox ];
    persist.dirs = [ ".config/mozilla/firefox" ];
    xdg.mime.enable = true;
  };
}
