{
  inputs,
  modules ? [],
}: let
  # get the lib from nixpkgs
  lib = inputs.nixpkgs.lib;

  # create a function that builds nixos systems
  buildHosts = hosts:
    builtins.mapAttrs (name: path:
      lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules =
          [
            # import the system config
            path

            # and use the system name as the hostName
            {networking.hostName = "${name}";}
          ]
          # import all provided modules
          ++ modules;
      })
    hosts;
in
  buildHosts {
    jetpack = ./jetpack;
  }
