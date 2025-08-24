{
  lib,
  config,
  ...
}: {
  imports = [
    ./btrfs
  ];

  options.custom.filesystem = {
    enable = lib.mkOption {
      type = lib.types.enum ["btrfs"];
      description = "Select which filesystem to use.";
    };

    bootDevice = lib.mkOption {
      type = lib.types.str;
      description = "Select which disk to use as the system boot device";
    };
  };

  config = {
    # mount the boot directory
    fileSystems = {
      "/boot" = {
        device = config.custom.filesystem.bootDevice;
        fsType = "vfat";
        options = ["fmask=0022" "dmask=0022"];
      };
    };

    # no swap devices for now
    swapDevices = [];
  };
}
