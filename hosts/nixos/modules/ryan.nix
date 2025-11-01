{
  lib,
  config,
  ...
}: let
  ryan = config.myconfig.users.ryan;
in {
  options.myconfig.users.ryan = {
    enable = lib.mkEnableOption "Enable ryan user";
  };

  config = lib.mkIf ryan.enable {
    # enable the igloo user
    igloo.users.ryan = {
      enable = true;
      config = {
        initialPassword = "ryan";
        extraGroups = ["wheel"];
      };
      homeConfig = {
        custom.impermanence = {
          enable = true;
          userDir = "/persist/home/ryan";
        };
      };
    };
  };
}
