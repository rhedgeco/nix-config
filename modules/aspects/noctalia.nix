{inputs, ...}: {
  den.aspects.noctalia.homeManager = {pkgs, ...}: {
    home.packages = [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    persist.dirs = [
      # only persist the calendar part of the cache
      # so calendar events persist without network
      ".cache/noctalia/calendar"
    ];
  };
}
