{ den, ... }: {
  den.hosts.x86_64-linux = {
    hedgebox = {
      stateVersion = "24.05";
      persist = "/persist";
      includes = [
        den.aspects.grub
        (den.aspects.autologin "ryan" "niri-session")
        den.aspects.bluetooth
        den.aspects.pipewire
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
          den.aspects.rust
          den.aspects.spotify
          den.aspects.color-picker
          den.aspects.yoink
        ];
      };
    };
  };
}
