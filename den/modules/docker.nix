{
  den.aspects.docker = {user, ...}: {
    provides.to-hosts.nixos = {
      virtualisation.docker.enable = true;
      users.users.${user.userName}.extraGroups = ["docker"];
    };
  };
}
