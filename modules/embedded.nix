{
  lib,
  pkgs,
  iglib,
  ...
}:
iglib.module {
  name = "embedded";

  packages = with pkgs; [
    saleae-logic-2
    stlink-gui
  ];

  nixos = {users, ...}: {
    config = {
      # include the udev packages with nixos systems
      services.udev.packages = with pkgs; [
        saleae-logic-2
        stlink-gui
      ];

      # give enabled users dialout access to the system
      users.users = lib.genAttrs users (name: {
        extraGroups = [
          "dialout"
        ];
      });
    };
  };
}
