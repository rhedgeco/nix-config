{
  inputs,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    extensions = with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
      kokakiwi.vscode-just
      kamadorueda.alejandra
      jnoortheen.nix-ide
      rust-lang.rust-analyzer
      michelemelluso.code-beautifier
      github.vscode-github-actions
      ms-python.python
      ms-python.black-formatter
    ];
  };

  # persist some editor data
  home.persistence."/persist/home/ryan" = {
    allowOther = true;
    directories = [
      ".config/Code/User/globalStorage"
      ".config/Code/User/workspaceStorage"
    ];
  };

  # set up dotfiles
  home.persistence."/persist/home/ryan/dotfiles" = {
    allowOther = true;
    removePrefixDirectory = true;
    files = [
      "vscode/.config/Code/User/settings.json"
    ];
  };
}
