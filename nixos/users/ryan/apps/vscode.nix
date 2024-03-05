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

    userSettings = {
      # editor setup
      "window.titleBarStyle" = "native";
      "window.commandCenter" = false;
      "editor.fontFamily" = "'Jetbrains Mono', 'monospace', monospace";

      # nix lsp setup
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
    };
  };
}
