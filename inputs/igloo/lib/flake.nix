{
  lib,
  iglib,
  igloo,
  inputs,
  ...
}: let
  flake = {
    extraSpecialArgs ? {},
    modules ? [],
    nixos ? {},
    users ? {},
  }: let
    # define base special args for all systems
    # include the igloo lib in the special args
    specialArgs = extraSpecialArgs // {inherit iglib;};

    # build the system module for each user
    userModules =
      lib.mapAttrsToList (
        name: module:
          iglib.userModule {
            inherit name;
            modules =
              # include this users module content
              (lib.toList module)
              # include igloo modules with every user
              ++ (lib.toList modules)
              # include the igloo home module
              ++ [igloo.homeModules.igloo];
          }
      )
      users;
  in {
    # build all nixos configurations from the system names found
    nixosConfigurations = lib.mapAttrs (name: module:
      lib.nixosSystem {
        # set the `iglooTarget` at the system level to `nixos`
        specialArgs = specialArgs // {iglooTarget = "nixos";};
        modules =
          # include this systems module content
          (lib.toList module)
          # include igloo modules with every nixos system
          ++ (lib.toList modules)
          # include all system user modules
          ++ userModules
          # include the igloo module
          ++ [igloo.nixosModules.igloo]
          # include the home manager module
          ++ [inputs.home-manager.nixosModules.home-manager]
          # include some resonable default configuration settings
          ++ [
            {
              # set the networking hostname to match the system name by default
              networking.hostName = lib.mkDefault "${name}";

              # pass special args and include `iglooTarget` as `home` instead
              home-manager.extraSpecialArgs = specialArgs // {iglooTarget = "home";};

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
