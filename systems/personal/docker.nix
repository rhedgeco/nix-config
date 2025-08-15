{...}: {
  virtualisation.docker.enable = true;

  users.users.ryan.extraGroups = [
    "docker"
  ];
}
