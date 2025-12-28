{pkgs, ...}: {
  igloo.modules.vscodium = {
    # enable igloo module for codium
    enable = true;

    # add extensions specific to ryan user
    extraExtensions = (
      with pkgs.nix-vscode-extensions.vscode-marketplace;
      with pkgs.vscode-extensions; [
        kdl-org.kdl
      ]
    );
  };

  # link vscode settings as a raw file
  igloo.create.".config/VSCodium/User/settings.json" = ./settings.json;
}
