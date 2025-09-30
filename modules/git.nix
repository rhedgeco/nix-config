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
    # start the ssh agent
    programs.ssh.startAgent = true;

    # enable git with lfs
    programs.git = {
      enable = true;
      lfs.enable = true;
    };
  };
}
