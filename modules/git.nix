{
  lib,
  pkgs,
  config,
  ...
}: let
  git = config.myconfig.git;
in {
  options.myconfig.git = {
    enable = lib.mkEnableOption "Enable git";
  };

  config = lib.mkIf git.enable {
    environment.systemPackages = [
      pkgs.git
      pkgs.git-lfs
    ];
  };
}
