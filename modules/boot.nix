{
  lib,
  iglib,
  ...
}:
iglib.module {
  name = "boot";
  enabled = true; # enabled by default

  nixos = {iglooModule, ...}: {
    # allow the user to set the boot device path
    options = {
      device = lib.mkOption {
        type = lib.types.str;
        description = "Disk to mount as the boot storage device.";
      };
    };

    # when enabled, set the boot directory to mount the boot device
    enabled.fileSystems = {
      "/boot" = {
        device = iglooModule.device;
        fsType = "vfat";
        options = ["fmask=0022" "dmask=0022"];
      };
    };
  };
}
