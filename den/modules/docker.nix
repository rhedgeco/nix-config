{
  den.aspects.docker = {
    user.extraGroups = ["docker"];

    nixos = {
      # enable docker on nixos
      virtualisation.docker.enable = true;
    };
  };
}
