{
  lib,
  pkgs,
  iglib,
  ...
}:
iglib.module {
  name = "vscodium";

  home = {iglooModule, ...}: {
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

        # include base extensions for editing nix files
        profiles.default.extensions =
          # include extra extensions defined elsewhere in the config
          iglooModule.extraExtensions
          # include base extensions for editing nix files
          ++ (with pkgs.vscode-extensions; [
            jnoortheen.nix-ide
            kamadorueda.alejandra
            skellock.just
            mkhl.direnv
          ]);
      };
    };
  };
}
