{
  lib,
  pkgs,
  config,
  ...
}: let
  keyring = config.myconfig.keyring;
in {
  options.myconfig.keyring = {
    enable = lib.mkEnableOption "Enable the gnome keyring";
  };

  config = lib.mkIf keyring.enable {
    # enable graphical interface for keys
    programs.seahorse.enable = true;

    # enable the keyring
    services.gnome.gnome-keyring.enable = true;

    # add dbus packages for keyring
    services.dbus.packages = [
      pkgs.gnome-keyring
      pkgs.gcr
    ];
  };
}
