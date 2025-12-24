{
  lib,
  iglib,
  ...
}:
iglib.module {
  name = "docker";

  nixos = ctx: {
    always = lib.mkIf ctx.users.anyEnabled {
      virtualisation.docker.enable = true;

      # any enabled user should have access to the docker group
      users.users = ctx.users.genEnabled (name: {
        extraGroups = [
          "docker"
        ];
      });
    };
  };
}
