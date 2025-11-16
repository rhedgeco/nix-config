{...}: {
  igloo.modules = {
    grub.enable = true;
    boot.device = "/dev/disk/by-label/BOOT";
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
