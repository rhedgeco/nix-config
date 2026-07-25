{
  den.aspects.docker = {
    nixos = {
      # enable docker on nixos
      virtualisation.docker.enable = true;
    };

    provides.to-hosts = {user, ...}: {
      # when a user includes this aspect, add them to the docker group
      nixos.users.users.${user.name}.extraGroups = ["docker"];
    };
  };
}
