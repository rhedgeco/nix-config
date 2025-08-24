{
  lib,
  config,
  ...
}: {
  options.custom.filesystem.btrfs = {
    mainDevice = lib.mkOption {
      type = lib.types.str;
      description = "Select which disk to use as the main btrfs storage device";
    };
  };

  config = lib.mkIf (config.custom.filesystem.enable == "btrfs") {
    # set docker to use the btrfs filesystem as its storage driver
    virtualisation.docker.storageDriver = "btrfs";

    # auto scrub btrfs filesystem
    services.btrfs.autoScrub = {
      enable = true;
      fileSystems = ["/btrfs"];
    };

    # mount all partitions/subvolumes
    fileSystems = {
      "/" = {
        device = config.custom.filesystem.btrfs.mainDevice;
        fsType = "btrfs";
        options = ["subvol=root" "compress=zstd"];
      };

      "/nix" = {
        device = config.custom.filesystem.btrfs.mainDevice;
        fsType = "btrfs";
        options = ["subvol=nix" "compress=zstd" "noatime"];
      };

      "/btrfs" = {
        device = config.custom.filesystem.btrfs.mainDevice;
        fsType = "btrfs";
        options = ["compress=zstd"];
      };
    };
  };
}
