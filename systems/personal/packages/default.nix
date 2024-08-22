{inputs, ...}: {
  imports = [
    # import all other packages
    ./code.nix
    ./core.nix
    ./cosmic.nix
    ./firefox.nix
    ./fonts.nix
    ./git.nix
    ./gnupg.nix
    ./grub.nix
    ./zsh.nix
  ];
}
