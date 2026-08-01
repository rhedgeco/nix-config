{
  den.aspects.jetpack.nixos = {
    hardware.bluetooth.enable = true;
    hardware.enableRedistributableFirmware = true;
    boot.initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "thunderbolt"
      "usb_storage"
      "sd_mod"
    ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    services.power-profiles-daemon.enable = true;
    services.hardware.bolt.enable = true;
    services.upower.enable = true;

    # set the hardware clock to local time to play nicely with windows
    time.hardwareClockInLocalTime = true;
    time.timeZone = "America/Los_Angeles";

    persist.dirs = [
      "/var/lib/power-profiles-daemon"
    ];
  };
}
