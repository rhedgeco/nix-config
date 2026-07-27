{den, ...}: {
  # add quirks that collect packages/fonts that need to be installed
  den.quirks.extraPackages.description = "extra packages to install on every included system";
  den.quirks.extraFonts.description = "extra fonts to install on every included system";

  # create an aspect that consumes the quirk and applies the packages
  den.aspects.install-extra-packages = {
    nixos = {
      extraPackages ? [],
      extraFonts ? [],
      ...
    }: {
      environment.systemPackages = extraPackages;
      fonts.packages = extraFonts;
    };
    homeManager = {
      extraPackages ? [],
      extraFonts ? [],
      ...
    }: {
      home.packages = extraPackages ++ extraFonts;
      fonts.fontconfig.enable = true;
    };
  };

  # include the install aspect on all host, user, and home systems
  den.default.includes = [
    den.aspects.install-extra-packages
  ];
}
