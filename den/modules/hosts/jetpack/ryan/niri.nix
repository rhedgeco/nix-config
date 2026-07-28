{den, ...}: {
  den.aspects.jetpack.provides.ryan.homeManager = {pkgs, ...}: {
    includes = [
      den.aspects.vicinae
    ];

    # TODO: Remove this
    # Persist the dconf directory for now
    # but later this should be replaced with a declarative solution
    persist.dirs = [
      ".config/dconf"
    ];

    # enable keyring related items
    services.gnome-keyring.enable = true;
    services.dbus.packages = with pkgs; [
      gnome-keyring
      seahorse
      gcr
    ];

    home.packages = with pkgs; [
      # niri does not have a built in x server
      # xwayland-satellite fills this gap
      # it hosts an xserver and simulates wayland clients
      xwayland-satellite
      alacritty
      nautilus
      gnome-calculator
    ];
  };
}
