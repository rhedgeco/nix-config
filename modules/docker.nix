{
  lib,
  iglib,
  ...
}:
iglib.module {
  name = "docker";

  nixos = {iglooUsers, ...}: {
    # always docker and groups when any users are enabled
    always = lib.mkIf iglooUsers.anyEnabled {
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
