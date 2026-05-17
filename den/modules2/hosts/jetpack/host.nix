{den, ...}: {
  den.hosts.x86_64-linux.jetpack = {
    persist.store = "/persist";
    users.ryan.persist = true;
  };

  den.aspects.jetpack = {
    includes = [
      # automatically log in as the ryan user
      (den.batteries.tty-autologin "ryan")

      # use grub for boot management
      den.aspects.grub
    ];

    nixos = {pkgs, ...}: {
      # use niri as the default login session
      # tty-autologin uses getty and will launch this command
      services.getty.loginProgram = "${pkgs.niri}/bin/niri-session";
    };
  };
}
