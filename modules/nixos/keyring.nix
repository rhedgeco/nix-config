{
  lib,
  config,
  ...
}: let
  keyring = config.myconfig.keyring;
in {
  options.myconfig.keyring = {
    enable = lib.mkEnableOption "Enable the gnome keyring";
  };

  config = lib.mkIf keyring.enable {
    # enable the keyring
    services.gnome.gnome-keyring.enable = true;
  };
}
