{
  den.aspects.embedded = {
    # any user with this aspect should have dialout access
    user.extraGroups = ["dialout"];

    nixos = {pkgs, ...}: {
      # udev packages have to be added to give them special access
      services.udev.packages = with pkgs; [
        saleae-logic-2
        stlink-gui
      ];
    };
  };
}
