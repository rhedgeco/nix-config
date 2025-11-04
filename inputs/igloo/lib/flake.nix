{
  lib,
  iglib,
  igloo,
  inputs,
  ...
}: let
  flake = {
    extraSpecialArgs ? {},
    modules ? {},
    nixos ? {},
    users ? {},
  }: let
    # define base special args for all systems
    # include the igloo lib in the special args
    specialArgs = extraSpecialArgs // {inherit iglib;};

    # define system type specific set of special args
    # this sets the `iglooTarget` argument allowing config switching
    homeSpecialArgs = specialArgs // {iglooTarget = "user";};
    nixosSpecialArgs = specialArgs // {iglooTarget = "nixos";};

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
          iglib.homeUserModule {
            inherit name;
            modules =
              # include the users module content
              module
              # include all modules defined at the user level
              ++ flakeModules.user
              # include all modules defined at the global level
              ++ flakeModules.global
              # include the igloo home module
              ++ [igloo.homeModules.igloo];
          }
      )
      users;
  in {
    # build all nixos configurations from the system names found
    nixosConfigurations = lib.mapAttrs (name: module:
      lib.nixosSystem {
        specialArgs = nixosSpecialArgs;
        modules =
          # include the systems module content
          module
          # include every home users module in the system
          ++ homeUserModules
          # include all modules defined at the nixos level
          ++ flakeModules.host
          # include all modules defined at the host level
          ++ flakeModules.nixos
          # include all modules defined at the global level
          ++ flakeModules.global
          # include the igloo module
          ++ [igloo.nixosModules.igloo]
          # include the home manager module
          ++ [inputs.home-manager.nixosModules.home-manager]
          # include some resonable default configuration settings
          ++ [
            {
              # set the networking hostname to match the system name by default
              networking.hostName = lib.mkDefault "${name}";

              # pass the home special args that include `iglib` and `iglooTarget`
              home-manager.extraSpecialArgs = homeSpecialArgs;

              # re-use the global system package store
              # saves space and re-downloading of packages
              home-manager.useGlobalPkgs = lib.mkDefault true;

              # By default packages will be installed to $HOME/.nix-profile
              # this options puts them in /etc/profiles
              # This is necessary if you wish to use nixos-rebuild build-vm.
              # This option may become the default value in the future.
              home-manager.useUserPackages = lib.mkDefault true;
            }
          ];
      })
    nixos;
  };
in {
  inherit flake;
}
