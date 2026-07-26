{
  den.aspects.embedded = {
    groups = ["dialout"];

    nixos = {pkgs, ...}: {
      services.udev.packages = with pkgs; [
        saleae-logic-2
        stlink-gui
      ];
    };
  };
}
