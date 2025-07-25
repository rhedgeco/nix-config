{
  pkgs,
  lib,
  stdenvNoCC,
  ...
}: {
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";

      # theming
      splashImage = ./splash.png;
      theme = pkgs.stdenv.mkDerivation {
        pname = "grub-solstice";
        version = "0.1.0";
        src = ./grub-solstice;
        installPhase = ''
          runHook preInstall

          mkdir -p $out/
          cp -r ./* "$out/"

          runHook postInstall
        '';
      };
    };
  };
}
