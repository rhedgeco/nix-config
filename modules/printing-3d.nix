{
  pkgs,
  iglib,
  ...
}:
iglib.module {
  name = "printing-3d";

  home.enabled.home.packages = with pkgs; [
    prusa-slicer
    printrun
  ];
}
