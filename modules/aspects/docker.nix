{
  den.aspects.docker = {
    # any user with this aspect should be added to the docker group
    user.extraGroups = [ "docker" ];

    nixos = {
      # enable docker on nixos
      virtualisation.docker.enable = true;
    };
  };
}
