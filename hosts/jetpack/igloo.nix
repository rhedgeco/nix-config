{...}: {
  igloo.modules = {
    grub.enable = true;
    steam.enable = true;
    boot.device = "/dev/disk/by-label/BOOT";

    greetd = {
      enable = true;
      autoLogin = "ryan";
    };

    persist = {
      enable = true;
      location = "/persist";
    };
  };

  igloo.users.ryan = {
    enable = true;
    config = {
      initialPassword = "ryan";
      extraGroups = ["wheel"];
    };
    home.custom.impermanence = {
      enable = true;
      userDir = "/persist/home/ryan";
    };
  };
}
