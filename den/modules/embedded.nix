{
  den.aspects.embedded = {
    # any user with this aspect should have dialout access
    user.extraGroups = ["dialout"];

    # udev packages have to be added at the nixos level
    nixos = {pkgs, ...}: {
      services.udev.packages = with pkgs; [
        saleae-logic-2
        stlink-gui
      ];
    };

    homeManager = {pkgs, ...}: {
      home.packages = with pkgs; [
        saleae-logic-2
        stlink-gui
      ];
    };
  };
}
