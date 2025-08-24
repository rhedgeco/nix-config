{...}: {
  custom = {
    dualBoot = true;

    bootloader.enable = "grub";

    hardware = {
      enable = "framework";
      framework = {
        edition = "framework-13-amd-7040";
      };
    };

    filesystem = {
      enable = "btrfs";
      bootDevice = "/dev/disk/by-label/BOOT";
      btrfs.mainDevice = "/dev/disk/by-label/MAIN";
    };
  };
}
