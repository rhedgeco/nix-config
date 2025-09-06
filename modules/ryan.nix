{
  lib,
  config,
  inputs,
  ...
}: {
  options.custom.users = {
    ryan.enable = lib.mkEnableOption "Enable ryan user";
  };

  config = lib.mkIf config.custom.users.ryan.enable {
    users.users.ryan = {
      isNormalUser = true;
      useDefaultShell = true;
      initialPassword = "ryan";
      extraGroups = ["wheel"];
    };
  };
}
