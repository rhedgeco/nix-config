{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yoink = {
      url = "path:./inputs/yoink";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    igloo = {
      url = "path:./inputs/igloo";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.igloo.lib.flake {
      # pass the inputs to all modules
      extraSpecialArgs = {inherit inputs;};

      # define global module locations
      modules = [./modules];

      # define nixos host module locations
      nixos.jetpack = [./hosts/jetpack];

      # define user host module locations
      users.ryan = [./users/ryan];
    };
}
