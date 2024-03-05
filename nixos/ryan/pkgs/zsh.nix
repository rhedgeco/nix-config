{
  # save history across boots
  home.persistence."/persist/home/ryan" = {
    allowOther = true;
    files = [
      ".zsh_history"
    ];
  };

  # set up dotfiles
  home.persistence."/persist/home/ryan/dotfiles" = {
    allowOther = true;
    removePrefixDirectory = true;
    files = [
      "zsh/.zshrc"
    ];
  };
}
