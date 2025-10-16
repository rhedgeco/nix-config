{
  pkgs,
  lib,
  config,
  ...
}: {
  options.myconfig.grub = {
    enable = lib.mkEnableOption "Enables custom grub config.";
  };

  config = lib.mkIf config.myconfig.grub.enable {
    boot.loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        timeout = 1;

        # theming
        splashImage = ./splash.png;
        theme = pkgs.stdenv.mkDerivation {
          pname = "grub-solstice";
          version = "0.1.0";
          src = ./solstice-theme;
          installPhase = ''
            runHook preInstall

            mkdir -p $out/
            cp -r ./* "$out/"

            runHook postInstall
          '';
        };
      };
    };
  };
}
