{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  # host specific settings
  nixpkgs.hostPlatform = "x86_64-linux";
  time.timeZone = "America/Los_Angeles";
  services.hardware.bolt.enable = true;
  hardware.enableRedistributableFirmware = true;
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];
}
