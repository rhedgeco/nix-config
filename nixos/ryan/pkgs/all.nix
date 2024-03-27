{pkgs, ...}: {
  # apps with config
  imports = [
    ./gnome.nix
    ./paperwm.nix
    ./ulauncher.nix
    ./firefox.nix
    ./vscode.nix
    ./zsh.nix
    ./rust.nix
    ./discord.nix
    ./git.nix
  ];

  # standalone packages
  home.packages = with pkgs; [
    blender
    alejandra
    nil
  ];
}
