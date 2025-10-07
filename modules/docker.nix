{
  lib,
  config,
  ...
}: let
  docker = config.myconfig.docker;
in {
  options.myconfig.docker = {
    enable = lib.mkEnableOption "Enable docker";
    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Users with permission to use docker";
    };
  };

  config = lib.mkIf docker.enable {
    # enable docker
    virtualisation.docker.enable = true;

    # add all specified users to the docker group
    users.users = lib.genAttrs docker.users (name: {
      extraGroups = [
        "docker"
      ];
    });
  };
}
