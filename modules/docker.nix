{
  lib,
  iglib,
  ...
}:
iglib.module {
  name = "docker";

  nixos = {users, ...}: {
    # always docker and groups when any users are enabled
    always = lib.mkIf users.anyEnabled {
      virtualisation.docker.enable = true;

      # any enabled user should have access to the docker group
      users.users = lib.genAttrs users.enabled (name: {
        extraGroups = [
          "docker"
        ];
      });
    };
  };
}
