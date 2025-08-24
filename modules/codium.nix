{
  lib,
  config,
  ...
}: {
  options.custom.codium = {
    enable = lib.mkEnableOption "Enable codium";
  };

  config = lib.mkIf config.custom.codium.enable {
    environment.systemPackages = with pkgs; [
      # only include base tools for editing nix files and using extensions
      alejandra
      just
      nil
      git
      git-lfs
      yoink

      # add vscode with base useful extensions
      (vscode-with-extensions.override {
        vscodeExtensions =
          (with pkgs.vscode-extensions; [
            jnoortheen.nix-ide
            kamadorueda.alejandra
            rust-lang.rust-analyzer
            tamasfe.even-better-toml
            vadimcn.vscode-lldb
            skellock.just
            ms-azuretools.vscode-docker
            mkhl.direnv
          ])
          ++ (with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
            barbosshack.crates-io
            kdl-org.kdl
          ]);
      })
    ];
  };
}
