{den, ...}: {
  den.aspects.discord = {
    # allow unfree discord package
    includes = [(den.batteries.unfree ["discord"])];

    homeManager = {pkgs, ...}: {
      home.packages = [pkgs.discord];

      persist.directories = [
        # persist the discord config directory
        # (im too lazy to configure it declaratively)
        ".config/discord"
      ];
    };
  };
}
