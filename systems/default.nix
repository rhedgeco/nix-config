inputs: {
  nixosConfigurations = import ./nixos {
    inherit inputs;
  };
}
