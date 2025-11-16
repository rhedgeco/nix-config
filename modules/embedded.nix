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
    # always enable udev rules and groups when any users are enabled
    always = lib.mkIf iglooUsers.anyEnabled {
      services.udev.packages = with pkgs; [
        saleae-logic-2
        stlink-gui
      ];

      # any enabled user should have access to the dialout group
      # this is required for users to have access to the usb ports
      users.users = lib.genAttrs iglooUsers.enabled (name: {
        extraGroups = [
          "dialout"
        ];
      });
    };
  };
}
