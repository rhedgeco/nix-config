{den, ...}: {
  # add a quirk that collects packages that need to be installed
  den.quirks.extraPackages.description = "extra packages to install on every included system";

  # create an aspect that consumes the quirk and applies the packages
  den.aspects.install-extra-packages = {
    nixos = {extraPackages ? [], ...}: {
      environment.systemPackages = extraPackages;
    };
    homeManager = {extraPackages ? [], ...}: {
      home.packages = extraPackages;
    };
  };

  # include the install aspect on all host, user, and home systems
  den.default.includes = [
    den.aspects.install-extra-packages
  ];
}
