{
  den.aspects.grub = {
    nixos.boot.loader = {
      timeout = 1;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        splashImage = ./_assets/splash.png;
        theme = ./_assets/solstice-theme;
      };
    };
  };
}
