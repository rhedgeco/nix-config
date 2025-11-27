{
  lib,
  pkgs,
  iglib,
  ...
}:
iglib.module {
  name = "vscodium";

  home = {iglooCtx, ...}: let
    # define the default extensions
    defaultExtensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      kamadorueda.alejandra
      skellock.just
      mkhl.direnv
    ];

    # define the extensions to enable if rust is enabled
    rustExtensions = lib.optionals (iglooCtx.modEnabled "rust") (
      with pkgs.nix-vscode-extensions.vscode-marketplace;
      with pkgs.vscode-extensions; [
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        vadimcn.vscode-lldb
        barbosshack.crates-io
      ]
    );
  in {
    options.extraExtensions = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      description = "Extra extension to add to vscodium";
      default = [];
    };

    enabled = {
      # include nixd for language server
      home.packages = [pkgs.nixd];

      programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
        mutableExtensionsDir = false;

        # merge all defined extensions into vscodium
        profiles.default.extensions =
          defaultExtensions
          ++ rustExtensions
          ++ iglooCtx.module.extraExtensions;
      };
    };
  };
}
