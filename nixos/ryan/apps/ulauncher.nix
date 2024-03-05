{pkgs, ...}: {
  home.packages = with pkgs; [
    ulauncher
  ];

  # set up dotfiles
  home.persistence."/persist/home/ryan/dotfiles" = {
    allowOther = true;
    removePrefixDirectory = true;
    files = [
      "ulauncher/.config/autostart/ulauncher.desktop"
    ];
    directories = [
      "ulauncher/.config/ulauncher"
    ];
  };
}
