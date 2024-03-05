{...}: {
  # set up dotfiles
  home.persistence."/persist/home/ryan/dotfiles" = {
    allowOther = true;
    removePrefixDirectory = true;
    files = [
      "paperwm/.config/paperwm/user.css"
    ];
  };
}
