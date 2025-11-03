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
      inherit lib inputs iglib call;
    };

    lib = nixpkgs.lib;
    iglib = call ./lib;
  in {
    lib = iglib;
  };
}
