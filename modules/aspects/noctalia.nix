{inputs, ...}: {
  den.aspects.noctalia.homeManager = {pkgs, ...}: {
    home.packages = [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    persist.dirs = [
      # TODO: slim this down to dedicated files/dirs
      # contains calendar themes and other state that should persist
      ".local/state/noctalia"

      # persist the cache so that various content sticks around
      ".cache/noctalia"
    ];
  };
}
