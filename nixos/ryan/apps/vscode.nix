{
  inputs,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    extensions = with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
      kokakiwi.vscode-just
      kamadorueda.alejandra
      jnoortheen.nix-ide
      rust-lang.rust-analyzer
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
