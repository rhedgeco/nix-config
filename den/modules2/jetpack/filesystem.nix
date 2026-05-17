{
  den.aspects.jetpack.nixos = {utils, ...}: let
    btrfsDisk = "/dev/disk/by-label/MAIN";
    btrfsDiskSystemdUnit = "${utils.escapeSystemdPath btrfsDisk}.device";
  in {
    # set docker to use the btrfs filesystem as its storage driver
    virtualisation.docker.storageDriver = "btrfs";

    # auto scrub btrfs filesystem
    services.btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = ["/"];
    };

    # mount all partitions/subvolumes
    fileSystems = {
      "/boot" = {
        device = btrfsDisk;
        fsType = "vfat";
        options = ["fmask=0022" "dmask=0022"];
      };

      "/" = {
        device = btrfsDisk;
        fsType = "btrfs";
        options = ["subvol=root" "compress=zstd"];
      };

      "/nix" = {
        device = btrfsDisk;
        fsType = "btrfs";
        options = ["subvol=nix" "compress=zstd" "noatime"];
      };

      "/persist" = {
        device = btrfsDisk;
        fsType = "btrfs";
        options = ["subvol=persist" "compress=zstd"];
        neededForBoot = true;
      };

      "/btrfs" = {
        device = btrfsDisk;
        fsType = "btrfs";
        options = ["compress=zstd"];
      };
    };

    # Super important until https://github.com/NixOS/nixpkgs/pull/435781 is default!
    # Otherwise, no initrd service will be created
    boot.initrd.systemd.enable = true;

    # create a systemd service to swap out the system root on boot
    # also looks through all old roots and removes any older than 30 days
    # swapped over from old config based on https://github.com/BryceBeagle/nixos-config/issues/374
    boot.initrd.systemd.services.wipe-btrfs-root = {
      description = "Wipe root btrfs subvolume for impermanence";
      wantedBy = ["initrd.target"];
      after = [btrfsDiskSystemdUnit];
      requires = [btrfsDiskSystemdUnit];

      # Must happen after the device is ready, but before /sysroot is mounted.
      before = ["sysroot.mount"];

      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";

      script = ''
        # mount the btrfs disk
        mkdir /btrfs_tmp
        mount -o compress=zstd ${btrfsDisk} /btrfs_tmp

        # if there is an existing root directory, move it to a backup directory
        if [[ -e /btrfs_tmp/root ]]; then
            echo "Found old root directory, creating backup..."
            mkdir -p /btrfs/backup/root
            timestamp=$(date --date="@$(stat -c %Y /btrfs/root)" "+%Y-%m-%-d_%H:%M:%S")
            mv /btrfs/root "/btrfs/backup/root/$timestamp"
        fi

        # define a function that recursively deletes btrfs subvolumes
        # just deleting a top level subvolume does not work
        # each subvolume must be deleted before the top level one can
        delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/btrfs/$i"
            done
            echo "Found old backup at $1, deleting..."
            btrfs subvolume delete "$1"
        }

        # look for old root directories
        # if one older than 30 days is found, recursively delete it
        echo "Scanning root backups for roots older than 30 days..."
        for i in $(find /btrfs/backup/root/* -maxdepth 0 -mtime +30); do
            delete_subvolume_recursively "$i"
        done

        # finally, we can build a fresh root directory to boot from
        echo "Building fresh root directory..."
        btrfs subvolume create /btrfs/root
        umount /btrfs
      '';
    };
  };
}
