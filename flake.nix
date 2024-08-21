{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    impermanence.url = "github:nix-community/impermanence";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    nixosConfigurations = {
      jetpack = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          {networking.hostName = "jetpack";}
          ./hardware/framework13
          ./systems/personal
        ];
      };
    };
  };
}
