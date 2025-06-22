{lib, ...}: {
  # auto scrub btrfs filesystem
  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = ["/btrfs"];
  };

  # set up docker to use btrfs
  virtualisation.docker.storageDriver = "btrfs";

  # mount all partitions/subvolumes
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/MAIN";
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd"];
    };

    "/nix" = {
      device = "/dev/disk/by-label/MAIN";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
    };

    "/home" = {
      device = "/dev/disk/by-label/MAIN";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd"];
    };

    "/persist" = {
      device = "/dev/disk/by-label/MAIN";
      fsType = "btrfs";
      options = ["subvol=persist" "compress=zstd"];
      neededForBoot = true;
    };

    "/btrfs" = {
      device = "/dev/disk/by-label/MAIN";
      fsType = "btrfs";
      options = ["compress=zstd"];
    };

    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };

  # no swap devices for now
  swapDevices = [];

  # create a root history on boot
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/disk/by-label/NIXOS /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/root_history
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/root_history/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';
}
