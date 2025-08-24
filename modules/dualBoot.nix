{
  lib,
  config,
  ...
}: {
  options.custom = {
    dualBoot = lib.mkOption {
      type = lib.types.bool;
      description = "Mark this system as being compatible with dual boot";
      default = false;
    };
  };

  config = lib.mkIf config.custom.dualBoot {
    # set the hardware clock to local time to play nicely with windows
    time.hardwareClockInLocalTime = true;
  };
}
