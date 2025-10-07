{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  codium = config.myconfig.codium;
  impermanence = config.myconfig.impermanence;
  rust = config.myconfig.rust;
in {
  options.myconfig.codium = {
    enable = lib.mkEnableOption "Enable vscodium editor.";
    extraExtensions = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Extra extensions to install with codium";
    };
  };

  config = lib.mkIf codium.enable {
    # apply the nix-vscode-extensions overlay
    nixpkgs.overlays = [inputs.nix-vscode-extensions.overlays.default];

    environment.systemPackages = with pkgs; [
      # only include base tools for editing nix files and using extensions
      alejandra
      just
      nixd

      # add codium with base useful extensions
      (vscode-with-extensions.override {
        vscode = pkgs.vscodium;
        vscodeExtensions =
          codium.extraExtensions
          # include extensions for nix files by default
          ++ (with pkgs.vscode-extensions; [
            jnoortheen.nix-ide
            kamadorueda.alejandra
            skellock.just
            mkhl.direnv
          ])
          # include rust extensions if rust is enabled
          ++ (lib.optionals rust.enable (
            # with syntax uses shadowing to resove the correct attribute
            # this means that if the extension is not in `vscode-extensions`
            # it will check in the `nix-vscode-extension.vscode-marketplace` instead
            # this means that any extensions that are not immediately available in the nix repo
            # can still be pulled from the entire marketplace
            with pkgs.nix-vscode-extensions.vscode-marketplace;
            with pkgs.vscode-extensions; [
              rust-lang.rust-analyzer
              tamasfe.even-better-toml
              vadimcn.vscode-lldb
              barbosshack.crates-io
            ]
          ));
      })
    ];

    # persist users codium global state database
    # remembers vscode window state between reboots
    # e.g. trusted folders, previously open projects, etc
    environment.persistence."/persist" = lib.mkIf impermanence.enable {
      users = lib.genAttrs impermanence.persistUsers (name: {
        files = [
          ".config/VSCodium/User/globalStorage/state.vscdb"
        ];
      });
    };
  };
}
