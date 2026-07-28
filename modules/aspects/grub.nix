{
  den.aspects.grub.nixos = {pkgs, ...}: {
    boot.loader = {
      timeout = 1;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";

        # theming
        splashImage = ./_assets/grub/splash.png;
        theme = pkgs.stdenv.mkDerivation {
          pname = "grub-solstice";
          version = "0.1.0";
          src = ./_assets/grub/solstice-theme;
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
