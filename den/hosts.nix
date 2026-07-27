{den, ...}: {
  den.hosts.x86_64-linux = {
    # personal laptop
    jetpack = {
      stateVersion = "24.05";
      persist = "/persist";
      includes = [
        den.aspects.steam
      ];

      users.ryan = {
        primary = true;
        persist = true;
        includes = [
          (den.batteries.user-shell "fish")
          den.aspects.fish
          den.aspects.starship
          den.aspects.direnv
          den.aspects.docker
          den.aspects.embedded
          den.aspects.rust
          den.aspects.spotify
          den.aspects.bambu
          den.aspects.discord
        ];
      };
    };
  };
}
