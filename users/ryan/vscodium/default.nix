{
  lib,
  # pkgs,
  config,
  ...
}: let
  impermanence = config.custom.impermanence;
in {
  # link vscode settings as a raw file
  igloo.create.".config/VSCodium/User/settings.json" = ./settings.json;

  # persist users codium global state database
  # remembers vscode window state between reboots
  # e.g. trusted folders, previously open projects, etc
  home.persistence = lib.mkIf impermanence.enable {
    "${impermanence.userDir}".files = [
      ".config/VSCodium/User/globalStorage/state.vscdb"
    ];
  };
}
