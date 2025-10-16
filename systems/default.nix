{
  inputs,
  users,
}: {
  nixosConfigurations = import ./nixos {
    inherit inputs users;
  };
}
