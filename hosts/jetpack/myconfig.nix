{...}: {
  myconfig = {
    dualBoot = true;

    shell.fish = {
      enable = true;
      setDefault = true;
    };

    filesystem = {
      btrfs = {
        enable = true;
        device = "/dev/disk/by-label/MAIN";
      };
    };

    impermanence = {
      enable = true;
      persistUsers = ["ryan"];
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
  };
}
