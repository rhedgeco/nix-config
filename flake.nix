{
  outputs = inputs: (import ./mylib inputs).den.flake ./.;

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
    yoink = {
      url = "path:./inputs/yoink";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-plugins-official = {
      url = "github:noctalia-dev/official-plugins";
      flake = false;
    };
    noctalia-plugins-community = {
      url = "github:noctalia-dev/community-plugins";
      flake = false;
    };
    abitoads = {
      url = "github:rhedgeco/abitoads/release";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
