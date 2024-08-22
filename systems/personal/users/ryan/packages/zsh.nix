{config, ...}: {
  programs.zsh = {
    enable = true;

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };

  # persist zsh history
  home.persistence."/persist${config.home.homeDirectory}" = {
    allowOther = true;
    files = [
      "${config.xdg.dataHome}/zsh/history"
    ];
  };
}
