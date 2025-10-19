{
  users,
  inputs,
}: {
  nixosConfigurations = import ./nixos {
    inherit inputs users;
  };
}
