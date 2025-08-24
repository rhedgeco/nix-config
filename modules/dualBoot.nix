{
  lib,
  config,
  ...
}: {
  options.custom.dualBoot = {
    enable = lib.mkEnableOption "Mark this system as being compatible with dual boot";
  };

  config = lib.mkIf config.custom.dualBoot.enable {
    # set the hardware clock to local time to play nicely with windows
    time.hardwareClockInLocalTime = true;
  };
}
