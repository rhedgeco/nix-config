{
  utils,
  users,
  inputs,
}: {
  nixosConfigurations = import ./nixos {
    inherit utils users inputs;
  };
}
