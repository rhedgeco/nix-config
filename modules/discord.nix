{
  pkgs,
  iglib,
  ...
}:
iglib.module {
  name = "discord";

  home.enabled = {
    home.packages = [pkgs.discord];

    # persist the discord config directory
    # (im too lazy to configure it declaratively)
    igloo.modules.persist.dirs = [
      ".config/discord"
    ];
  };
}
