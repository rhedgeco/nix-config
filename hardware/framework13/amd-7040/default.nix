{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # set time zone
  time.timeZone = "America/Los_Angeles";

  # set up kernel modules
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  nixpkgs.hostPlatform = "x86_64-linux";

  # set hardware clock to use local time
  # this is so that it matches for a windows dual boot
  time.hardwareClockInLocalTime = true;

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

  # backup any old root directories on boot
  # this will create a fresh root each time and store backups for 30 days
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs
    mount -o compress=zstd /dev/disk/by-label/MAIN /btrfs
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
}
