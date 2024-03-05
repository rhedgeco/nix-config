{inputs, ...}: {
  imports = ["${inputs.impermanence}/home-manager.nix"];

  # set up dotfiles
  home.persistence."/persist/home/ryan/dotfiles" = {
    removePrefixDirectory = true;
    files = [
      "zsh/.zshrc"
      "ulauncher/.config/autostart/ulauncher.desktop"
    ];
    directories = [
      "ulauncher/.config/ulauncher"
    ];
  };
}
