{
  den.aspects.jetpack = {
    nixos = {...}: {
      time.timeZone = "America/Los_Angeles";
      hardware.bluetooth.enable = true;
      services.hardware.bolt.enable = true;
      hardware.enableRedistributableFirmware = true;
      boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod"];
      boot.initrd.kernelModules = [];
      boot.kernelModules = ["kvm-amd"];
      boot.extraModulePackages = [];

      # set the hardware clock to local time to play nicely with windows dual boot
      time.hardwareClockInLocalTime = true;

      # persist some system files
      persist = {
        files = [
          "/etc/machine-id"
        ];
        directories = [
          "/var/log" # system log files
          "/var/lib/nixos" # needed for nixos systems
          "/var/lib/systemd/coredump" # systemd coredump info
        ];
      };
    };
  };
}
