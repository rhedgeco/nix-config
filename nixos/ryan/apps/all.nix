{pkgs, ...}: {
  # apps with config
  imports = [
    ./ulauncher.nix
    ./firefox.nix
    ./vscode.nix
    ./zsh.nix
  ];

  # standalone packages
  home.packages = with pkgs; [
    alejandra
    nil
    zoom-us
  ];
}
