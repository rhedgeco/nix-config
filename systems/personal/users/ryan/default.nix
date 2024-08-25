{inputs, ...}: {
  # initialize user
  users.users = {
    ryan = {
      isNormalUser = true;
      useDefaultShell = true;
      initialPassword = "ryan";
      extraGroups = ["wheel" "networkmanager"];
    };
  };

  # set up home manager
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users.ryan = import ./home.nix;
  };
}
