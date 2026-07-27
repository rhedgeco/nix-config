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
          den.aspects.fishy
          den.aspects.docker
          den.aspects.embedded
          den.aspects.rust
          den.aspects.spotify
          den.aspects.bambu
          den.aspects.discord
          den.aspects.vicinae
        ];
      };
    };
  };
}
