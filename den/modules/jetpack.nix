{den, ...}: {
  # configure the jetpack system
  den.hosts.x86_64-linux.jetpack = {
    persist.path = "/persist";
    users.ryan.persist = true;
  };

  # include system specific configuration in the jetpack aspect
  den.aspects.jetpack = {
    includes = [
      (den.provides.tty-autologin "ryan")
    ];

    nixos = {pkgs, ...}: {
      services.getty.loginProgram = "${pkgs.niri}/bin/niri-session";
      environment.systemPackages = [pkgs.hello];
      boot.loader.grub.enable = false; # TODO: remove for real hardware
      fileSystems."/".device = "/dev/null";
    };
  };
}
