{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  # host specific settings
  nixpkgs.hostPlatform = "x86_64-linux";
  time.timeZone = "America/Los_Angeles";
  hardware.bluetooth.enable = true;
  services.hardware.bolt.enable = true;
  hardware.enableRedistributableFirmware = true;
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  # TODO: find better solution to network throttling
  boot.extraModprobeConfig = ''
    options iwlwifi swcrypto=1 bt_coex_active=1
  '';
  networking.networkmanager.settings.connection = {
    "wifi.powersave" = 2;
  };

  # TODO: remove when stage1 scripts are migrated
  boot.initrd.systemd.enable = false;

  # TODO: remove when networking bug is fixed
  boot.kernelPackages = pkgs.linuxPackages_6_12;
}
