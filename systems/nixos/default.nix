{
  users,
  inputs,
}: let
  # get the lib from nixpkgs
  lib = inputs.nixpkgs.lib;

  # get the lib from igloo
  iglib = inputs.igloo.lib;

  # create a function that builds nixos systems
  buildHosts = hosts:
    builtins.mapAttrs (name: path:
      lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs users;};
        modules =
          # set every systems hostname to match their directory
          [{networking.hostName = "${name}";}]
          # import all global nixos system modules
          ++ iglib.findModules ./modules
          # import all modules in the system dir
          ++ iglib.findModules path;
      })
    hosts;
in
  buildHosts {
    jetpack = ./jetpack;
  }
