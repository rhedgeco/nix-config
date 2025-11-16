{
  pkgs,
  iglib,
  ...
}:
iglib.module {
  name = "printing-3d";

  home.config.home.packages = with pkgs; [
    prusa-slicer
    printrun
  ];
}
