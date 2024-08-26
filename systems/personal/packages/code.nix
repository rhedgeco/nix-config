{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    nil
    alejandra
    gcc
    rustup
    python3
    just

    (vscode-with-extensions.override {
      vscodeExtensions = with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
        jnoortheen.nix-ide
        kamadorueda.alejandra
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        fill-labs.dependi
        ms-python.python
        ms-python.black-formatter
        kokakiwi.vscode-just
      ];
    })
  ];
}
