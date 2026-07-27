{den, ...}: {
  den.hosts.x86_64-linux = {
    jetpack = {
      persist = "/persist";
      stateVersion = "24.05";
      users.ryan = {
        primary = true;
        persist = true;
        includes = [
          den.aspects.docker
          den.aspects.embedded
          den.aspects.rust
          den.aspects.spotify
        ];
      };
    };
  };
}
