{
  lib,
  config,
  ...
}: let
  impermanence = config.custom.impermanence;
in {
  home.persistence = lib.mkIf impermanence.enable {
    "${impermanence.userDir}".directories = [
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
      {
        directory = ".steam";
        method = "symlink";
      }
    ];
  };
}
