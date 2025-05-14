{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # only include base tools for editing nix files
    alejandra
    just
    nil

    # add vscode with base useful extensions
    (vscode-with-extensions.override {
      vscodeExtensions = with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
        jnoortheen.nix-ide
        kamadorueda.alejandra
        kokakiwi.vscode-just
        ms-azuretools.vscode-docker
        mkhl.direnv
      ];
    })
  ];
}
