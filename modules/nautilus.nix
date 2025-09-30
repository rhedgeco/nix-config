{
  lib,
  pkgs,
  config,
  ...
}: let
  nautilus = config.myconfig.nautilus;
in {
  options.myconfig.nautilus = {
    enable = lib.mkEnableOption "Enable nautilus file manager";
  };

  config = lib.mkIf nautilus.enable {
    # add nautilus package to the environment
    environment.systemPackages = [
      pkgs.nautilus
    ];
  };
}
