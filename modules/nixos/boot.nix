{
  lib,
  config,
  ...
}: let
  boot = config.myconfig.filesystem.boot;
in {
  options.myconfig.filesystem.boot = {
    device = lib.mkOption {
      type = lib.types.str;
      description = "Disk to mount as the boot storage device.";
    };
  };

  config = {
    # mount the boot directory
    fileSystems = {
      "/boot" = {
        device = boot.device;
        fsType = "vfat";
        options = ["fmask=0022" "dmask=0022"];
      };
    };
  };
}
