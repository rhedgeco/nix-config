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

  nixosModule = {iglooModule, ...}: {
    environment.systemPackages = lib.optional iglooModule.enableCowsay pkgs.cowsay;
  };

  homeModule = {iglooModule, ...}: {
    options.enablePokemonsay = lib.mkEnableOption "Enable pokemonsay";
    config = {
      igloo.modules.test.enablePokemonsay = true;
      home.packages = lib.optional (iglooModule.enablePokemonsay && iglooModule.enableCowsay) pkgs.pokemonsay;
    };
  };
}
