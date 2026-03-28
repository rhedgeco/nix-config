{
  pkgs,
  iglib,
  ...
}:
iglib.module {
  name = "spotify";

  home.enabled = {
    home.packages = [pkgs.spotify];

    igloo.modules.persist.dirs = [
      ".config/spotify"
    ];
  };
}
