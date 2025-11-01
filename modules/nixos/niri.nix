{
  lib,
  pkgs,
  config,
  ...
}: let
  niri = config.myconfig.niri;
  impermanence = config.myconfig.impermanence;
in {
  options.myconfig.niri = {
    enable = lib.mkEnableOption "Enable niri compositor.";
  };

  config = lib.mkIf niri.enable {
    # enable the niri compositor
    programs.niri.enable = true;

    # TODO: Remove this
    # Persist the dconf directory for now
    # but later this should be replaced with a declarative solution
    environment.persistence."/persist" = lib.mkIf impermanence.enable {
      users = lib.genAttrs impermanence.persistUsers (name: {
        directories = [
          ".config/dconf"
        ];
      });
    };

    # enable/configure the gnome keyring when using niri
    programs.seahorse.enable = true;
    services.gnome.gnome-keyring.enable = true;
    security.pam.services = {
      greetd.enableGnomeKeyring = true;
      greetd-password.enableGnomeKeyring = true;
      login.enableGnomeKeyring = true;
    };
    services.dbus.packages = [pkgs.gnome-keyring pkgs.gcr];

    # add packages used by niri
    environment.systemPackages = with pkgs; [
      # niri does not have a built in x server
      # xwayland-satellite fills this gap
      # it hosts an xserver and simulates wayland clients
      xwayland-satellite
      alacritty
      fuzzel
      waybar
      hyprlock
      hyprpaper
      gnome-calculator
    ];
  };
}
