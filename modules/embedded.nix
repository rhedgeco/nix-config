{
  lib,
  pkgs,
  iglib,
  ...
}:
iglib.module {
  name = "embedded";

  home.enabled.home.packages = with pkgs; [
    saleae-logic-2
    stlink-gui
  ];

  nixos = {users, ...}: {
    # always add udev rules and user groups if any users have this module enabled
    always = lib.mkIf users.anyEnabled {
      services.udev.packages = with pkgs; [
        saleae-logic-2
        stlink-gui
      ];

      users.users = lib.genAttrs users.enabled (name: {
        extraGroups = [
          "dialout"
        ];
      });
    };
  };
}
