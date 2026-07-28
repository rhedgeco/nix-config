let
  btrfsDevice = "/dev/disk/by-label/MAIN";
in {
  den.aspects.jetpack.nixos = {
    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-label/BOOT";
        fsType = "vfat";
        options = ["fmask=0022" "dmask=0022"];
      };

      "/" = {
        device = btrfsDevice;
        fsType = "btrfs";
        options = ["subvol=root" "compress=zstd"];
      };

      "/nix" = {
        device = btrfsDevice;
        fsType = "btrfs";
        options = ["subvol=nix" "compress=zstd" "noatime"];
      };

      "/persist" = {
        device = btrfsDevice;
        fsType = "btrfs";
        options = ["subvol=persist" "compress=zstd"];
        neededForBoot = true;
      };

      "/btrfs" = {
        device = btrfsDevice;
        fsType = "btrfs";
        options = ["compress=zstd"];
      };
    };
  };
}
