{
  den.aspects.dolphin = {
    nixos = {pkgs, ...}: {
      services.udev.packages = [pkgs.dolphin-emu];
    };

    homeManager = {pkgs, ...}: {
      home.packages = [pkgs.dolphin-emu];
      persist.dirs = [
        # main dolphin config
        # TODO: maybe make this declarative
        ".config/dolphin-emu"

        # dolphin save data locations, etc...
        ".local/share/dolphin-emu"
      ];
    };
  };
}
