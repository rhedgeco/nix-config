{pkgs, ...}: {
  # apps with config
  imports = [
    ./firefox.nix
    ./vscode.nix
  ];

  # standalone packages
  home.packages = with pkgs; [
    ulauncher
    alejandra
    nil
    zoom-us
  ];
}
