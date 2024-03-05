{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../system/config.nix
  ];

  networking.hostName = "hedge";
  time.timeZone = "America/Los_Angeles";

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = ["/"];
  };

  boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/nvme0n1p3";
    fsType = "btrfs";
    options = ["subvol=root" "compress=zstd"];
  };

  fileSystems."/nix" = {
    device = "/dev/nvme0n1p3";
    fsType = "btrfs";
    options = ["subvol=nix" "compress=zstd" "noatime"];
  };

  fileSystems."/persist" = {
    device = "/dev/nvme0n1p3";
    neededForBoot = true;
    fsType = "btrfs";
    options = ["subvol=persist" "compress=zstd"];
  };

  fileSystems."/btrfs_root" = {
    device = "/dev/nvme0n1p3";
    neededForBoot = true;
    fsType = "btrfs";
    options = ["compress=zstd"];
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/nvme0n1p2";}
  ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    if [[ -e /btrfs_root/root ]]; then
        mkdir -p /btrfs_root/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_root/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_root/root "/btrfs_root/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_root/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_root/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_root/root
  '';
}
