{
  description = "ryan's nix system configuration";

  inputs = {
    den.url = "github:denful/den";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    import-tree.url = "github:denful/import-tree";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
  };

  outputs = inputs:
    (inputs.nixpkgs.lib.evalModules {
      specialArgs = {inherit inputs;};
      modules = [
        inputs.den.flakeModule # import flakeModule to generate top level flake config
        (inputs.import-tree ./modules) # import all module configuration
        ./hosts.nix # import all host configuration
      ];
    }).config.flake;
}
