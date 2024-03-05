{pkgs, ...}: {
  # apps with config
  imports = [
    ./paperwm.nix
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
