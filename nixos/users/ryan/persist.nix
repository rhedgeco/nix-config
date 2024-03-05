{inputs, ...}: {
  imports = ["${inputs.impermanence}/home-manager.nix"];

  # set up dotfiles
  home.persistence."/persist/home/ryan/dotfiles" = {
    removePrefixDirectory = true;
    files = [
      "zsh/.zshrc"
    ];
    directories = [
    ];
  };
}
