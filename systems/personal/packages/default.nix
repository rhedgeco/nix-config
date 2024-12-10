{inputs, ...}: {
  imports = [
    # import home-manager and impermanence
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence

    # import complex modules
    ./printers

    # import all other modules
    ./browser.nix
    ./code.nix
    ./core.nix
    ./docker.nix
    ./fonts.nix
    ./git.nix
    ./gnupg.nix
    ./grub.nix
    ./ly.nix
    ./zsh.nix
  ];
}
