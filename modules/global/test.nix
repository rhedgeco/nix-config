{
  lib,
  pkgs,
  iglib,
  ...
}:
iglib.module {
  name = "test";
  enable = true;

  global = {...}: {
    options.enableCowsay = lib.mkEnableOption "Enable cowsay";
  };

  nixos = {iglooModule, ...}: {
    igloo.module.test.enableCowsay = true;
    environment.systemPackages = lib.optional iglooModule.enableCowsay pkgs.cowsay;
  };

  user = {iglooModule, ...}: {
    options.enableGum = lib.mkEnableOption "Enable cowsay";
    config = {
      igloo.module.test.enableGum = true;
      home.packages = lib.optional iglooModule.enableGum pkgs.gum;
    };
  };
}
