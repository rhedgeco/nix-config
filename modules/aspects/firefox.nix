{
  den.aspects.firefox.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.firefox ];
    persist.dirs = [ ".mozilla" ];
    xdg.mime.enable = true;
  };
}
