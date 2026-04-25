{...}: {
  den.aspects.embedded = {user, ...}: {
    homeManager = {pkgs, ...}: {
      home.packages = with pkgs; [
        saleae-logic-2
        stlink-gui
      ];
    };

    nixos = {pkgs, ...}: {
      services.udev.packages = with pkgs; [
        saleae-logic-2
        stlink-gui
      ];

      users.users.${user.userName}.extraGroups = ["dialout"];
    };
  };
}
