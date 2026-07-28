let
  btrfsDisk = "/dev/disk/by-label/MAIN";
in {
  den.aspects.jetpack.nixos = {utils, ...}: {
    # set docker to use the btrfs filesystem as its storage driver
    virtualisation.docker.storageDriver = "btrfs";

    # auto scrub btrfs filesystem
    services.btrfs.autoScrub = {
      enable = true;
      fileSystems = ["/btrfs"];
    };

    fileSystems = {
      "/" = {
        device = btrfsDisk;
        fsType = "btrfs";
        options = ["subvol=root" "compress=zstd"];
      };

      "/boot" = {
        device = "/dev/disk/by-label/BOOT";
        fsType = "vfat";
        options = ["fmask=0022" "dmask=0022"];
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

    # Thank you BryceBeagle!
    # based on https://github.com/BryceBeagle/nixos-config/blob/5a0ca440118488d427410ce49a06c3aca376509f/modules/config/impermanence.nix#L57
    # Super important until https://github.com/NixOS/nixpkgs/pull/435781 is default!
    # Otherwise, no initrd service will be created
    boot.initrd.systemd.enable = true;

    # create a systemd stage 1 service that backs up old root directories on boot
    # this will create a fresh root each time and will wipe backups older than 30 days
    boot.initrd.systemd.services.wipe-btrfs-root = let
      btrfsDiskSystemdUnit = "${utils.escapeSystemdPath btrfsDisk}.device";
    in {
      description = "Wipe root btrfs subvolume for impermanence";
      wantedBy = ["initrd.target"];

      # This must match the actual btfrs device label
      after = [btrfsDiskSystemdUnit];
      requires = [btrfsDiskSystemdUnit];

      # Must happen after the device is ready, but before /sysroot is mounted.
      before = ["sysroot.mount"];

      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";

      script = ''
        mkdir /btrfs
        mount -o compress=zstd ${btrfsDisk} /btrfs
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
  };
}
