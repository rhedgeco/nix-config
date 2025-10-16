{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  ryan = config.myconfig.users.ryan;
  yoink = inputs.yoink.packages.${pkgs.system}.default;
in {
  options.myconfig.users = {
    ryan.enable = lib.mkEnableOption "Enable ryan user";
  };

  config = lib.mkIf ryan.enable {
    # create the ryan user
    users.users.ryan = {
      isNormalUser = true;
      useDefaultShell = true;
      initialPassword = "ryan";
      extraGroups = ["wheel"];
    };

    # create systemd service that populates all the yoinkfiles
    systemd.services.yoink-push-ryan = {
      description = "Manages dotfiles for ryan";
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        User = "ryan";
        Group = "users";
        Type = "oneshot";
      };

      script = ''
        ${yoink}/bin/yoink -r ${./yoinkfiles} push
      '';
    };
  };
}
