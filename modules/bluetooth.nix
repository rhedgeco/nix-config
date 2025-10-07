{
  lib,
  config,
  ...
}: let
  bluetooth = config.myconfig.bluetooth;
in {
  options.myconfig.bluetooth = {
    enable = lib.mkEnableOption "Enable bluetooth";
  };

  config = lib.mkIf bluetooth.enable {
    # enable the bluetooth hardware
    hardware.bluetooth.enable = true;

    # enable the blueman bluetooth service
    services.blueman.enable = true;
  };
}
