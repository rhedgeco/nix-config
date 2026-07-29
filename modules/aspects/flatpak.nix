{
  den.aspects.flatpak.nixos = {pkgs, ...}: {
    services.flatpak.enable = true;
    persist.dirs = ["/var/lib/flatpak"];

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
      config.common.default = ["gtk"];
    };
  };
}
