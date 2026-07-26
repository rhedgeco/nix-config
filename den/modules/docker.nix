{
  den.aspects.docker = {
    groups = ["docker"];

    nixos = {
      # enable docker on nixos
      virtualisation.docker.enable = true;
    };
  };
}
