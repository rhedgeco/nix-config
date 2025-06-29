{inputs, ...}: {
  imports = [
    # import impermanence module
    inputs.impermanence.homeManagerModules.impermanence

    # import all other modules
    ./modules
  ];

  # set home data
  home = {
    username = "ryan";
    homeDirectory = "/home/ryan";
  };

  # enable home-manager
  programs.home-manager.enable = true;

  # set up initial perist with config dir
  home.persistence."/persist" = {
    allowOther = true;
    directories = [
      # "nix-config"
    ];
  };

  # state version
  home.stateVersion = "24.05";
}
