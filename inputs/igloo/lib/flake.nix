{
  lib,
  iglib,
  inputs,
  ...
}: let
  mkFlake = {
    extraSpecialArgs ? {},
    modules ? {},
    nixos ? {},
    users ? {},
  }: let
    # define the special args for all systems
    # also include the igloo lib in all special args
    specialArgs = extraSpecialArgs // {inherit iglib;};

    # define and set defaults for all flake module paths
    flakeModules =
      {
        global = [];
        host = [];
        nixos = [];
        user = [];
      }
      // modules;

    # build the system module for each user
    homeUserModules =
      lib.mapAttrsToList (
        name: module:
          iglib.mkHomeUserModule {
            inherit name;
            modules =
              module
              # include all modules defined at the user level
              ++ flakeModules.user
              # include all modules defined at the global level
              ++ flakeModules.global;
          }
      )
      users;

    # create a the home manager setup confgiguration defaults
    homeManagerSetup = {
      # import the home manager module
      imports = [inputs.home-manager.nixosModules.home-manager];

      # pass iglib and extraSpecialArgs to home manager as well
      home-manager.extraSpecialArgs = specialArgs;

      # re-use the global system package store
      # saves space and re-downloading of packages
      home-manager.useGlobalPkgs = lib.mkDefault true;

      # By default packages will be installed to $HOME/.nix-profile
      # this options puts them in /etc/profiles
      # This is necessary if you wish to use nixos-rebuild build-vm.
      # This option may become the default value in the future.
      home-manager.useUserPackages = lib.mkDefault true;
    };
  in {
    # build all nixos configurations from the system names found
    nixosConfigurations = lib.mapAttrs (name: module:
      lib.nixosSystem {
        specialArgs = specialArgs;
        modules =
          module
          # include every home users module in the system
          ++ homeUserModules
          # include all modules defined at the nixos level
          ++ flakeModules.host
          # include all modules defined at the host level
          ++ flakeModules.nixos
          # include all modules defined at the global level
          ++ flakeModules.global
          # set the hostname of the system to match by default
          ++ [{networking.hostName = lib.mkDefault "${name}";}]
          # include the home manager setup config only if there are home users
          ++ (lib.optional (builtins.length homeUserModules != 0) homeManagerSetup);
      })
    nixos;
  };
in {
  inherit mkFlake;
}
