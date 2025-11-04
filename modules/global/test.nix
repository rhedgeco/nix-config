{
  lib,
  pkgs,
  iglib,
  ...
}:
iglib.module {
  name = "test";
  enabled = false;

  options.enableCowsay = lib.mkEnableOption "Enable cowsay";

  igloo.modules.test.enableCowsay = true;

  nixos = {iglooModule, ...}: {
    environment.systemPackages = lib.optional iglooModule.enableCowsay pkgs.cowsay;
  };

  user = {iglooModule, ...}: {
    options.enableGum = lib.mkEnableOption "Enable pokemonsay";
    config = {
      igloo.modules.test.enableGum = true;
      home.packages = lib.optional (iglooModule.enableGum && iglooModule.enableCowsay) pkgs.gum;
    };
  };
}
