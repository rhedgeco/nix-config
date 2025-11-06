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

  options.users = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    description = "List of users with 'dialout' access";
    default = [];
  };

  nixos = {module, ...}: {
    # include the udev packages with nixos systems
    services.udev.packages = with pkgs; [
      saleae-logic-2
      stlink-gui
    ];

    # give enabled users dialout access to the system
    users.users = lib.genAttrs module.users (name: {
      extraGroups = [
        "dialout"
      ];
    });
  };
}
