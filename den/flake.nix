{
  outputs = inputs:
    (inputs.nixpkgs.lib.evalModules {
      modules = [(inputs.import-tree ./modules)];
      specialArgs = {inherit inputs;};
    }).config.flake;

  inputs = {
    den.url = "github:vic/den";
    impermanence.url = "github:nix-community/impermanence";
    import-tree.url = "github:vic/import-tree";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
}
