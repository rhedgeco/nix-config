{
  outputs = inputs:
    (inputs.nixpkgs.lib.evalModules {
      modules = [(inputs.import-tree ./modules)];
      specialArgs = {inherit inputs;};
    }).config.flake;

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    import-tree.url = "github:vic/import-tree";
    den.url = "github:vic/den";
  };
}
