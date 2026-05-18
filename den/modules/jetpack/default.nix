{den, ...}: {
  den.aspects.jetpack = {
    includes = [
      # use grub for boot management
      den.aspects.grub

      # automatically log in as the ryan user
      (den.batteries.tty-autologin "ryan")

      # use niri as the main desktop environment
      den.aspects.niri

      # include steam for gaming on this system
      den.aspects.steam
    ];
  };
}
