{
  lib,
  iglib,
  ...
}:
iglib.module {
  name = "docker";

  nixos = {users, ...}: {
    always = lib.mkIf users.anyEnabled {
      # enable docker on the system
      virtualisation.docker.enable = true;

      # give enabled users dialout access to the system
      users.users = lib.genAttrs users.enabled (name: {
        extraGroups = [
          "docker"
        ];
      });
    };
  };
}
