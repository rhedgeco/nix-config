{pkgs, ...}: {
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
    keyring.enable = true;
    rust.enable = true;
    git.enable = true;
  };
}
