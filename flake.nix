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
    inputs.igloo.lib.mkFlake {
      extraSpecialArgs = {inherit inputs;};

      # define global module locations
      modules = {
        host = [./hosts/nixos/modules];
        user = [./users/modules];
      };

      # define user module locations
      users.ryan = [./users/ryan];

      # define nixos module locations
      nixos.jetpack = [./hosts/nixos/jetpack];
    };
}
