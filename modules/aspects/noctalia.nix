{ inputs, ... }: {
  den.aspects.noctalia.homeManager = { pkgs, ... }: {
    home.packages = [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    # create the empty setup complete file
    # this prevents the welcome banner from appearing
    create.".local/state/noctalia/.setup-complete" = "";

    persist.dirs = [
      # only persist the calendar part of the cache
      # so calendar events persist without network
      ".cache/noctalia/calendar"
    ];
  };
}
