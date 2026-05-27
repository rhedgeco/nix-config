{
  description = "ryan's nix system configuration";

  inputs = {
    den.url = "github:denful/den";
    impermanence.url = "github:nix-community/impermanence";
    import-tree.url = "github:vic/import-tree";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      flake = false;
    };
  };

  outputs = inputs:
    (inputs.nixpkgs.lib.evalModules {
      modules = [(inputs.import-tree ./modules)];
      specialArgs = {inherit inputs;};
    }).config.flake;
}
