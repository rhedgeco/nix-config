{inputs, ...}: {
  imports = ["${inputs.impermanence}/home-manager.nix"];

  # set up dotfiles
  home.persistence."/persist/home/ryan/dotfiles" = {
    allowOther = true;
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
