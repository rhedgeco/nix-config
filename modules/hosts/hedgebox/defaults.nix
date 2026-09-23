{
  den.aspects.hedgebox.nixos = {
    programs.dconf.enable = true;
    hardware.enableRedistributableFirmware = true;
    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "rtsx_pci_sdmmc"
    ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];
    time.timeZone = "America/Los_Angeles";
    security.polkit.enable = true;
  };
}
