{
  inputs,
  pkgs,
  ...
}: {
  # only include base tools for editing nix
  environment.systemPackages = with pkgs; [
    nil
    alejandra
    just

    (vscode-with-extensions.override {
      vscodeExtensions = with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
        jnoortheen.nix-ide
        kamadorueda.alejandra
        kokakiwi.vscode-just
        ms-vscode-remote.remote-containers
        ms-azuretools.vscode-docker
        tomoki1207.pdf
      ];
    })
  ];
}
