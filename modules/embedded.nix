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

  nixos = {iglooUsers, ...}: {
    always = lib.mkIf iglooUsers.anyEnabled {
      services.udev.packages = with pkgs; [
        saleae-logic-2
        stlink-gui
      ];

      # any enabled user should have access to the dialout group
      # this is required for users to have access to the usb ports
      users.users = iglooUsers.genEnabled (name: {
        extraGroups = [
          "dialout"
        ];
      });
    };
  };
}
