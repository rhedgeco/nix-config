{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    impermanence.url = "github:nix-community/impermanence";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
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
