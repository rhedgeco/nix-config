{pkgs, ...}: {
  home.packages = [
    pkgs.prusa-slicer
    pkgs.printrun
  ];
}