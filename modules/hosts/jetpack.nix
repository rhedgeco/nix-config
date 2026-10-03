{ den, ... }: {
  den.hosts.x86_64-linux = {
    jetpack = {
      stateVersion = "24.05";
      persist = "/persist";
      includes = [
        den.aspects.grub
        (den.aspects.windows-boot "Windows Gaming" "09F9-0507")
        (den.aspects.autologin "ryan" "niri-session")
        den.aspects.bluetooth
        den.aspects.pipewire
        den.aspects.steam
      ];

      users.ryan = {
        primary = true;
        persist = true;
        password = "ryan";
        includes = [
          den.aspects.keyring
          den.aspects.glade
          den.aspects.network
          den.aspects.fishy
          den.aspects.docker
          den.aspects.embedded
          den.aspects.rust
          den.aspects.spotify
          den.aspects.discord
          den.aspects.color-picker
          den.aspects.dolphin
          den.aspects.bambu
          den.aspects.yoink
        ];
      };
    };
  };
}
