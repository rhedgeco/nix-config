{
  utils,
  users,
  inputs,
}: let
  # get the lib from nixpkgs
  lib = inputs.nixpkgs.lib;

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
          ++ utils.modulePaths ./modules
          # import all modules in the system dir
          ++ utils.modulePaths path;
      })
    hosts;
in
  buildHosts {
    jetpack = ./jetpack;
  }
