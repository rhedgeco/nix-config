{
  lib,
  pkgs,
  config,
  ...
}: let
  impermanence = config.custom.impermanence;
in {
  # include formatters lsps for extensions
  home.packages = with pkgs; [
    alejandra
    nixd
  ];

  # create the codium settings json file
  home.file.".config/VSCodium/User/settings.json" = {
    text = builtins.readFile ./settings.json;
    force = true;
  };

  # persist users codium global state database
  # remembers vscode window state between reboots
  # e.g. trusted folders, previously open projects, etc
  home.persistence = lib.mkIf impermanence.enable {
    "${impermanence.userDir}".files = [
      ".config/VSCodium/User/globalStorage/state.vscdb"
    ];
  };

  # enable and configure the base install of vscodium
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    # include extensions for editing nix files
    profiles.default.extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      kamadorueda.alejandra
      skellock.just
      mkhl.direnv
    ];
  };
}
