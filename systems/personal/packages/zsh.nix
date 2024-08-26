{pkgs, ...}: {
  users.defaultUserShell = pkgs.zsh;
  environment = {
    shells = with pkgs; [zsh];
    variables.EDITOR = "vim";
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      theme = "gnzh";
    };
  };
}
