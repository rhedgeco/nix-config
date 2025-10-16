inputs: {
  nixosConfigurations = import ./nixos {
    modules = [./modules];
    inherit inputs;
  };
}
