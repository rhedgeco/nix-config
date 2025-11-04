{
  pkgs,
  iglib,
  ...
}: let
  cli-packages = with pkgs; [
    just
    gum
  ];
in
  iglib.module {
    name = "cli-tools";
    nixos = {...}: {environment.systemPackages = cli-packages;};
    user = {...}: {home.packages = cli-packages;};
  }
