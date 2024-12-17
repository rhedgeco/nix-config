{inputs, ...}: {
  imports = [
    # import home-manager and impermanence
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence

    # import complex modules
    ./printers
    ./grub

    # import all other modules
    ./browser.nix
    ./code.nix
    ./core.nix
    ./docker.nix
    ./fonts.nix
    ./git.nix
    ./gnome.nix
    ./gnupg.nix
    ./shell.nix
  ];
}
