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
    # create the ryan user
    users.users.ryan = {
      isNormalUser = true;
      useDefaultShell = true;
      initialPassword = "ryan";
      extraGroups = ["wheel"];
    };

    # enable the igloo user
    igloo.users.ryan = {
      enable = true;
      extraConfig = {
        custom.impermanence = {
          enable = true;
          userDir = "/persist/home/ryan";
        };
      };
    };
  };
}
