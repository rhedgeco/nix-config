{
  lib,
  iglib,
  inputs,
  ...
}: let
  mkFlake = {
    src,
    extraSpecialArgs ? {},
  }: let
    # define host paths
    hostDir = src + "/hosts";
    hostModuleDir = hostDir + "/modules";

    # define nixos host paths
    nixosDir = hostDir + "/nixos";
    nixosModuleDir = nixosDir + "/modules";

    # define user paths
    userDir = src + "/users";
    userModuleDir = userDir + "/modules";

    # collect the global modules for all systems and users
    globalHostModules = iglib.findModules hostModuleDir;
    globalNixosModules = iglib.findModules nixosModuleDir;
    globalUserModules = iglib.findModules userModuleDir;

    # collect all the nixos system names
    nixosNames = lib.attrNames (
      lib.filterAttrs (
        # include all directories that are not "modules"
        fileName: fileType:
          fileType == "directory" && fileName != "modules"
      ) (builtins.readDir nixosDir)
    );

    # collect all user names
    userNames = lib.attrNames (
      lib.filterAttrs (
        # include all directories that are not "modules"
        fileName: fileType:
          fileType == "directory" && fileName != "modules"
      ) (builtins.readDir userDir)
    );

    # build the system module for each user
    userNameModules = lib.map (name: let
      userModules = iglib.findModules (userDir + "/${name}");
    in
      iglib.mkUserModule {
        inherit name;
        modules = userModules ++ globalUserModules;
      })
    userNames;
  in {
    # build all nixos configurations from the system names found
    nixosConfigurations = lib.listToAttrs (lib.map (name: let
        hostModules = iglib.findModules (nixosDir + "/${name}");
      in {
        inherit name;
        value = lib.nixosSystem {
          specialArgs = {inherit iglib;} // extraSpecialArgs;
          modules =
            hostModules
            # include every user module in the system
            ++ userNameModules
            # include all modules defined at the host level
            ++ globalHostModules
            # include all modules defined at the nixos level
            ++ globalNixosModules
            ++ [
              ({...}: {
                # import the home manager module by default
                imports = [inputs.home-manager.nixosModules.home-manager];

                # set the hostname of the system to match by default
                networking.hostName = lib.mkDefault "${name}";

                # pass extra special args to home manager as well
                home-manager.extraSpecialArgs = extraSpecialArgs;

                # re-use the global system package store by default
                # saves space and re-downloading of packages
                home-manager.useGlobalPkgs = lib.mkDefault true;

                # By default packages will be installed to $HOME/.nix-profile
                # this options puts them in /etc/profiles
                # This is necessary if you wish to use nixos-rebuild build-vm.
                # This option may become the default value in the future.
                home-manager.useUserPackages = lib.mkDefault true;
              })
            ];
        };
      })
      nixosNames);
  };
in {
  inherit mkFlake;
}
