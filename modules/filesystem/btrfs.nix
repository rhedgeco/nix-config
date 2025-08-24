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

      # mount the persist subvolume if impermanence is enabled
      "/persist" = lib.mkIf config.custom.impermanence.enable {
        device = config.custom.filesystem.btrfs.mainDevice;
        fsType = "btrfs";
        options = ["subvol=persist" "compress=zstd"];
        neededForBoot = true;
      };

      "/btrfs" = {
        device = config.custom.filesystem.btrfs.mainDevice;
        fsType = "btrfs";
        options = ["compress=zstd"];
      };
    };

    # if impermanence is enabled, back up old root directories on boot
    # this will create a fresh root each time and store backups for 30 days
    boot.initrd.postDeviceCommands = lib.mkIf config.custom.impermanence.enable ''
      mkdir /btrfs
      mount -o compress=zstd ${config.custom.filesystem.btrfs.mainDevice} /btrfs
      if [[ -e /btrfs/root ]]; then
          echo "Found old root directory, creating backup..."
          mkdir -p /btrfs/backup/root
          timestamp=$(date --date="@$(stat -c %Y /btrfs/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs/root "/btrfs/backup/root/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs/$i"
          done
          echo "Found old backup at $1, deleting..."
          btrfs subvolume delete "$1"
      }

      echo "Scanning root backups for roots older than 30 days..."
      for i in $(find /btrfs/backup/root/* -maxdepth 0 -mtime +30); do
          delete_subvolume_recursively "$i"
      done

      echo "Building fresh root directory..."
      btrfs subvolume create /btrfs/root
      umount /btrfs
    '';
  };
}
