{
  lib,
  users,
  ...
}: {
  options.myconfig.users.ryan = {
    enable = lib.mkEnableOption "Enable ryan user";
  };

  config = {
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
    };
  };
}
