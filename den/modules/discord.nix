{...}: {
  den.aspects.discord = {
    homeManager = {pkgs, ...}: {
      home.packages = [pkgs.discord];
    };

    persist-home.directories = [
      # persist the discord config directory
      # (im too lazy to configure it declaratively)
      ".config/discord"
    ];
  };
}
