{pkgs, ...}: {
  # apps with config
  imports = [
    ./firefox.nix
    ./vscode.nix
  ];

  # standalone packages
  home.packages = with pkgs; [
    zoom-us
    alejandra
    nil
  ];
}
