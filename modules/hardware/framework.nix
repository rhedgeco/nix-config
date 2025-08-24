{
  lib,
  config,
  inputs,
  ...
}: let
  hardware = config.custom.hardware;
in {
  options.custom.hardware.framework = {
    edition = lib.mkOption {
      type = lib.types.enum ["framework-13-amd-7040"];
      description = "Select this systems framework edition.";
    };
  };

  config = lib.mkIf (hardware.enable == "framework" && hardware.framework.edition == "framework-13-amd-7040") {
    boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-amd"];
    boot.extraModulePackages = [];

    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
