{den, ...}: {
  den.hosts.x86_64-linux.jetpack.users.ryan = {};

  den.aspects.jetpack = {
    includes = [
      # set jetpack to autologin the ryan user
      (den.provides.tty-autologin "ryan")
    ];

    nixos = {pkgs, ...}: {
      # set the login program to run when ryan logs in
      services.getty.loginProgram = "${pkgs.niri}/bin/niri-session";

      environment.systemPackages = [pkgs.hello];
      boot.loader.grub.enable = false; # TODO: remove for real hardware
      fileSystems."/".device = "/dev/null";
    };
  };
}
