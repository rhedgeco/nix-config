{
  den.aspects.discord.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.discord ];

    # persist the discord config directory
    # (im too lazy to configure it declaratively)
    persist.dirs = [ ".config/discord" ];

    # add discord to vicinae favorites if used
    den.vicinae.settings.favorites = [
      "applications:discord"
    ];
  };
}
