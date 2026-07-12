{
  description = "ryan's nix system configuration";

  inputs = {
    den.url = "github:denful/den";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
  };

  outputs = inputs: let
    # extend the nix lib with custom library content
    lib = inputs.nixpkgs.lib.extend (import ./lib);
  in
    # eval all den modules and extract the generated flake configuration
    (lib.evalModules {
      specialArgs = {inherit inputs;};
      modules = [./modules ./hosts];
    }).config.flake;
}
