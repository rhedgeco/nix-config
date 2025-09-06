{pkgs, ...}: {
  custom = {
    users = {
      ryan.enable = true;
    };

    hardware = {
      enable = "framework";
      framework = {
        edition = "framework-13-amd-7040";
      };
    };

    filesystem = {
      enable = "btrfs";
      bootDevice = "/dev/disk/by-label/BOOT";
      btrfs.mainDevice = "/dev/disk/by-label/MAIN";
    };

    impermanence = {
      enable = true;
      persistDir = "/persist";
    };

    greetd = {
      enable = true;
      autoLogin = {
        command = "${pkgs.niri}/bin/niri-session";
        user = "ryan";
      };
    };

    dualBoot.enable = true;
    bootloader.enable = "grub";
    codium.enable = true;
    niri.enable = true;
  };
}
