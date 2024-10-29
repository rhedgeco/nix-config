{inputs, ...}: {
  imports = [
    # import home-manager and impermanence
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence

    # import all other packages
    ./code.nix
    ./core.nix
    ./docker.nix
    ./firefox.nix
    ./fonts.nix
    ./git.nix
    ./gnome.nix
    ./gnupg.nix
    ./grub.nix
    ./printer.nix
    ./zsh.nix
  ];
}
