{
  lib,
  users,
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

    # set up the home manager configuration for ryan
    home-manager.users.ryan = users.buildHome {
      name = "ryan";
      config.custom = {
        impermanence = {
          enable = true;
          userDir = "/home/ryan";
        };
      };
    };
  };
}
