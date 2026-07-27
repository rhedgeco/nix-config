{
  den.aspects.flatpak.nixos = {
    services.flatpak.enable = true;
    persist.dirs = ["/var/lib/flatpak"];
  };
}
