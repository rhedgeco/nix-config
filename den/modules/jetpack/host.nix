{den, ...}: {
  den.hosts.x86_64-linux = {
    jetpack = {
      stateVersion = "24.05";
      users.ryan = {
        primary = true;
        includes = [
          den.aspects.docker
          den.aspects.embedded
          den.aspects.rust
        ];
      };
    };
  };
}
