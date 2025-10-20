{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
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
      url = "github:rhedgeco/yoink";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    igloo = {
      url = "path:./igloo";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs: let
    # import users module
    users = import ./users inputs;

    # import systems module
    systems = import ./systems {
      inherit inputs users;
    };
  in {
    # use the systems module to generate nixosConfigurations
    nixosConfigurations = systems.nixosConfigurations;
  };
}
