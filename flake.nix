{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yoink = {
      url = "github:rhedgeco/yoink";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {...} @ inputs: let
    utils = import ./utils.nix {inherit inputs;};
  in {
    nixosConfigurations = utils.buildHosts {
      jetpack = ./hosts/jetpack.nix;
    };
  };
}
