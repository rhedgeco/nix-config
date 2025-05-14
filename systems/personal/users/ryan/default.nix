{inputs, ...}: {
  # initialize user
  users.users = {
    ryan = {
      isNormalUser = true;
      useDefaultShell = true;
      initialPassword = "ryan";
      extraGroups = ["wheel" "docker" "networkmanager" "dialout" "nixconfig"];
    };
  };

  # set up home manager
  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs;};
    users.ryan = import ./home.nix;
  };
}
