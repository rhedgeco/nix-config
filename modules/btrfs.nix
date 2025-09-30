{
  lib,
  config,
  ...
}: let
  btrfs = config.myconfig.filesystem.btrfs;
  impermanence = config.myconfig.impermanence;
in {
  options.myconfig.filesystem.btrfs = {
    enable = lib.mkEnableOption "Enable my custom btrfs as the filesystem.";
    device = lib.mkOption {
      type = lib.types.str;
      description = "Disk to use as the main btrfs storage device.";
    };
  };

  config = lib.mkIf btrfs.enable {
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
        device = btrfs.device;
        fsType = "btrfs";
        options = ["subvol=root" "compress=zstd"];
      };

      "/nix" = {
        device = btrfs.device;
        fsType = "btrfs";
        options = ["subvol=nix" "compress=zstd" "noatime"];
      };

      # mount the persist subvolume if impermanence is enabled
      "/persist" = lib.mkIf impermanence.enable {
        device = btrfs.device;
        fsType = "btrfs";
        options = ["subvol=persist" "compress=zstd"];
        neededForBoot = true;
      };

      "/btrfs" = {
        device = btrfs.device;
        fsType = "btrfs";
        options = ["compress=zstd"];
      };
    };

    # if impermanence is enabled, back up old root directories on boot
    # this will create a fresh root each time and store backups for 30 days
    boot.initrd.postDeviceCommands = lib.mkIf impermanence.enable (lib.mkAfter ''
      mkdir /btrfs
      mount -o compress=zstd ${btrfs.device} /btrfs
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
    '');
  };
}
