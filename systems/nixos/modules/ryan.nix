{
  lib,
  config,
  inputs,
  ...
}: let
  iglib = inputs.igloo.lib;
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
    home-manager = {
      extraSpecialArgs = {inherit iglib;};
      users.ryan = iglib.mkUserHome {
        name = "ryan";
        modules = (iglib.findModules ../../../users/modules) ++ (iglib.findModules ../../../users/ryan);
        extraConfig = {
          custom.impermanence = {
            enable = true;
            userDir = "/persist/home/ryan";
          };
        };
      };
    };
  };
}
