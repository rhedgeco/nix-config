{inputs, ...}: {
  imports = [
    # import home-manager and impermanence
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence

    # import complex modules
    ./printers

    # import all other modules
    ./code.nix
    ./core.nix
    ./docker.nix
    ./firefox.nix
    ./fonts.nix
    ./git.nix
    ./gnome.nix
    ./gnupg.nix
    ./grub.nix
    ./zsh.nix
  ];
}
