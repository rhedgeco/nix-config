{
  outputs =
    inputs@{ nixpkgs, import-tree, ... }:
    (nixpkgs.lib.evalModules {
      modules = [ (import-tree ./modules) ];
      specialArgs = {
        mylib = import ./mylib nixpkgs.lib;
        inherit inputs;
      };
    }).config.flake;

  inputs = {
    den.url = "github:denful/den";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    import-tree.url = "github:denful/import-tree";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yoink = {
      url = "path:./inputs/yoink";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
