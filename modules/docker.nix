{
  lib,
  iglib,
  ...
}:
iglib.module {
  name = "docker";

  nixos = {iglooUsers, ...}: {
    always = lib.mkIf iglooUsers.anyEnabled {
      virtualisation.docker.enable = true;

      # any enabled user should have access to the docker group
      users.users = iglooUsers.genEnabled (name: {
        extraGroups = [
          "docker"
        ];
      });
    };
  };
}
