{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.niri.packages.${pkgs.system}.default
    pkgs.xwayland-satellite
  ];
}
