{
  outputs = inputs:
    (inputs.nixpkgs.lib.evalModules {
      modules = [(inputs.import-tree ./modules)];
      specialArgs = {inherit inputs;};
    }).config.flake;

  inputs = {
    den.url = "github:denful/den";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    import-tree.url = "github:denful/import-tree";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
