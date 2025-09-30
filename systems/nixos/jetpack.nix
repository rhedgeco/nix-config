{
  pkgs,
  modulesPath,
  inputs,
  ...
}: {
  # import the framework 13 amd hardware configuration
  imports = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # add kernel modules requires for this system
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  # set my custom config options
  myconfig = {
    dualBoot = true;
    grub.enable = true;

    users = {
      ryan.enable = true;
    };

    shell.fish = {
      enable = true;
      setDefault = true;
    };

    filesystem = {
      boot.device = "/dev/disk/by-label/BOOT";
      btrfs = {
        enable = true;
        device = "/dev/disk/by-label/MAIN";
      };
    };

    impermanence = {
      enable = true;
      persistUsers = ["ryan"];
    };

    greetd = {
      enable = true;
      autoLogin = {
        command = "${pkgs.niri}/bin/niri-session";
        user = "ryan";
      };
    };

    bluetooth.enable = true;
    networkmanager = {
      enable = true;
      powersave = true;
      users = ["ryan"];
    };

    docker = {
      enable = true;
      users = ["ryan"];
    };

    embedded = {
      enable = true;
      serialUsers = ["ryan"];
    };

    niri.enable = true;
    codium.enable = true;
    firefox.enable = true;
    nautilus.enable = true;
    rust.enable = true;
    git.enable = true;
  };
}
