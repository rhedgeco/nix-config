{
  lib,
  iglib,
  ...
}:
iglib.module {
  name = "docker";

  nixos = {users, ...}: {
    config = {
      # enable docker on the system
      virtualisation.docker.enable = true;

      # give enabled users dialout access to the system
      users.users = lib.genAttrs users (name: {
        extraGroups = [
          "docker"
        ];
      });
    };
  };
}
