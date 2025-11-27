{
  lib,
  iglib,
  ...
}:
iglib.module {
  name = "docker";

  nixos = {iglooCtx, ...}: {
    always = lib.mkIf iglooCtx.users.anyEnabled {
      virtualisation.docker.enable = true;

      # any enabled user should have access to the docker group
      users.users = iglooCtx.users.genEnabled (name: {
        extraGroups = [
          "docker"
        ];
      });
    };
  };
}
