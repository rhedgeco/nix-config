{
  lib,
  pkgs,
  iglib,
  inputs,
  ...
}:
iglib.module {
  name = "vscodium";

  # apply the extensions overlay for more extension access
  overlays = [inputs.nix-vscode-extensions.overlays.default];

  home = ctx: {
    options.extraExtensions = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      description = "Extra extension to add to vscodium";
      default = [];
    };

    enabled = let
      # define the default extensions
      defaultExtensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        kamadorueda.alejandra
        skellock.just
        mkhl.direnv
      ];

      # define the extensions to enable if rust is enabled
      rustExtensions = lib.optionals (ctx.modEnabled "rust") (
        with pkgs.nix-vscode-extensions.vscode-marketplace;
        with pkgs.vscode-extensions; [
          rust-lang.rust-analyzer
          tamasfe.even-better-toml
          vadimcn.vscode-lldb
          barbosshack.crates-io
        ]
      );
    in {
      # include nixd for language server
      home.packages = [pkgs.nixd];

      # persist users codium global state database
      # remembers vscode window state between reboots
      # e.g. trusted folders, previously open projects, etc
      igloo.modules.persist.files = [
        ".config/VSCodium/User/globalStorage/state.vscdb"
      ];

      # enable and configure vscode
      programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
        mutableExtensionsDir = false;

        # merge all defined extensions into vscodium
        profiles.default.extensions =
          defaultExtensions
          ++ rustExtensions
          ++ ctx.module.extraExtensions;
      };
    };
  };
}
