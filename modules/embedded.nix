{
  lib,
  pkgs,
  config,
  ...
}: let
  embedded = config.myconfig.embedded;
in {
  options.myconfig.embedded = {
    enable = lib.mkEnableOption "Enable embedded development";
    serialUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Give users with read/write to serial ports";
    };
  };

  config = lib.mkIf embedded.enable {
    # add the saleae logic package
    environment.systemPackages = [
      pkgs.saleae-logic-2
      pkgs.stlink-gui
    ];

    # include required udev services
    services.udev.packages = [
      pkgs.saleae-logic-2
      pkgs.stlink-gui
    ];

    # add serial port users to dialout group
    users.users = lib.genAttrs embedded.serialUsers (name: {
      extraGroups = [
        "dialout"
      ];
    });
  };
}
