{
  inputs,
  users,
}: let
  # get the lib from nixpkgs
  lib = inputs.nixpkgs.lib;

  # create a function that builds nixos systems
  buildHosts = hosts:
    builtins.mapAttrs (name: path:
      lib.nixosSystem {
        specialArgs = {inherit inputs users;};
        modules = [
          # import the system config
          path

          # import all nixos modules
          ./modules

          # use the system name as the hostName
          {networking.hostName = "${name}";}
        ];
      })
    hosts;
in
  buildHosts {
    jetpack = ./jetpack;
  }
