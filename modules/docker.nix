{
  lib,
  iglib,
  ...
}:
iglib.module {
  name = "docker";

  nixos = {iglooUsers, ...}: {
    enabled = {
      virtualisation.docker.enable = true;

      # any enabled user should have access to the docker group
      users.users = lib.genAttrs iglooUsers.enabled (name: {
        extraGroups = [
          "docker"
        ];
      });
    };
  };
}
