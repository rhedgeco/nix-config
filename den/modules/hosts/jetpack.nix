{den, ...}: {
  den.hosts.x86_64-linux = {
    jetpack = {
      stateVersion = "24.05";
      persist = "/persist";
      includes = [
        den.aspects.grub
        (den.aspects.autologin "ryan" "niri-session")
        den.aspects.steam
      ];

      users.ryan = {
        primary = true;
        persist = true;
        includes = [
          den.aspects.niri
          den.aspects.network
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
