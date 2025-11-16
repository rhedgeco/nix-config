{pkgs, ...}: {
  myconfig = {
    dualBoot = true;
    grub.enable = true;

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

    networkmanager = {
      enable = true;
      powersave = true;
      users = ["ryan"];
    };

    niri.enable = true;
    firefox.enable = true;
    nautilus.enable = true;
    keyring.enable = true;
    rust.enable = true;
  };
}
