{
  pkgs,
  iglib,
  ...
}:
iglib.module {
  name = "legcord";

  home.enabled = {
    # use legcord as an alternative discord client
    home.packages = [pkgs.legcord];

    # persist the legcord config directory
    # (im too lazy to configure it declaratively)
    igloo.modules.persist.dirs = [
      ".config/legcord"
    ];
  };
}
