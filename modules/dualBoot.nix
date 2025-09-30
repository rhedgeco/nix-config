{
  lib,
  config,
  ...
}: let
  dualBoot = config.myconfig.dualBoot;
in {
  options.myconfig.dualBoot = lib.mkEnableOption "Mark this system as being compatible with dual boot";

  config = lib.mkIf dualBoot {
    # set the hardware clock to local time to play nicely with windows
    time.hardwareClockInLocalTime = true;
  };
}
