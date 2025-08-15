{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.saleae-logic-2
  ];

  services.udev.packages = [
    pkgs.saleae-logic-2
    pkgs.stlink
  ];

  users.users.ryan.extraGroups = [
    "dialout"
  ];
}
