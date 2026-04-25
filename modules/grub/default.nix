{iglib, ...}:
iglib.module {
  name = "grub";

  nixos.enabled = {
    boot.loader = {
      timeout = 1;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";

        # theming
        splashImage = ./splash.png;
        theme = ./solstice-theme;
      };
    };
  };
}
