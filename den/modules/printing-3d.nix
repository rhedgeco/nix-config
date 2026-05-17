{
  den.aspects.printing-3d = {
    homeManager = {pkgs, ...}: {
      home.packages = with pkgs; [
        prusa-slicer
        printrun
      ];
    };
  };
}
