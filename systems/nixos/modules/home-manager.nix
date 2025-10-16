{inputs, ...}: {
  imports = [
    # import the home manager module
    inputs.home-manager.nixosModules.home-manager
  ];

  # pass inputs to home manager so user modules can use it
  home-manager.extraSpecialArgs = {inherit inputs;};

  # re-use the global system package store
  # saves space and re-downloading of packages
  home-manager.useGlobalPkgs = true;

  # By default packages will be installed to $HOME/.nix-profile
  # this options puts them in /etc/profiles
  # This is necessary if you wish to use nixos-rebuild build-vm.
  # This option may become the default value in the future.
  home-manager.useUserPackages = true;

  # if there exists a file where home manager is trying to make a symlink
  # instead of failing it will backup the old file with the "*.backup" extension.
  home-manager.backupFileExtension = "backup";
}
