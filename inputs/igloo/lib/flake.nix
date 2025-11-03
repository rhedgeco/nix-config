{
  lib,
  iglib,
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
    # this sets the `iglooType` argument allowing config switching
    homeSpecialArgs = specialArgs // {iglooType = "user";};
    nixosSpecialArgs = specialArgs // {iglooType = "nixos";};

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
              ++ flakeModules.global;
          }
      )
      users;

    # setup home manager confgiguration defaults
    homeManagerSetup = {
      # import the home manager module
      imports = [inputs.home-manager.nixosModules.home-manager];

      # pass iglib and extraSpecialArgs to home manager as well
      home-manager.extraSpecialArgs = homeSpecialArgs;

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
        specialArgs = nixosSpecialArgs;
        modules =
          # include the systems module content
          module
          # include the home manager setup
          ++ [homeManagerSetup]
          # include every home users module in the system
          ++ homeUserModules
          # include all modules defined at the nixos level
          ++ flakeModules.host
          # include all modules defined at the host level
          ++ flakeModules.nixos
          # include all modules defined at the global level
          ++ flakeModules.global
          # set the hostname of the system to match by default
          ++ [{networking.hostName = lib.mkDefault "${name}";}];
      })
    nixos;
  };
in {
  inherit flake;
}
