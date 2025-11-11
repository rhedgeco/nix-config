{
  pkgs,
  iglib,
  ...
}:
iglib.module {
  name = "printing-3d";

  packages = with pkgs; [
    prusa-slicer
    printrun
  ];
}
