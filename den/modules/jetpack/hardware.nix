{inputs, ...}: {
  den.aspects.jetpack.nixos = {pkgs, ...}: {
    # use framework13 hardware settings from nixos hardware repo
    imports = [inputs.nixos-hardware.nixosModules.framework-13-7040-amd];

    # other hardware settings
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

    # use niri as the default getty login session
    services.getty.loginProgram = "${pkgs.niri}/bin/niri-session";

    # persist some system files between boots
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
}
