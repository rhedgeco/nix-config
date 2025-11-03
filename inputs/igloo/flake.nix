{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    # `call` is a function that automatically imports with certain params
    # the `lib.flip` essentially combines the import with a set of parameters
    call = lib.flip import {
      inherit lib inputs call iglib modules;
    };

    lib = nixpkgs.lib;
    iglib = call ./lib;
    modules = call ./modules;
  in {
    lib = iglib;
    nixosModules = {
      default = modules.nixos.igloo;
      igloo = modules.nixos.igloo;
    };
  };
}
