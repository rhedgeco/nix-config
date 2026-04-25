{den, ...}: {
  # configure the jetpack system
  den.hosts.x86_64-linux.jetpack = {
    persist.store = "/persist";
    users.ryan.persist = true;
  };

  # include system specific configuration in the jetpack aspect
  den.aspects.jetpack = {
    includes = [
      (den.provides.tty-autologin "ryan")
      den.aspects.grub
      den.aspects.niri
      den.aspects.printing-3d
    ];

    nixos = {pkgs, ...}: {
      services.getty.loginProgram = "${pkgs.niri}/bin/niri-session";
    };
  };
}
