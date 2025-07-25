{inputs, ...}: {
  imports = [
    inputs.impermanence.homeManagerModules.impermanence
  ];

  home = {
    username = "ryan";
    homeDirectory = "/home/ryan";
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Ryan Hedgecock";
    userEmail = "rhedgeco@gmail.com";
  };

  # enable home-manager
  programs.home-manager.enable = true;

  # set up initial perist with config dir
  home.persistence."/persist/users/ryan" = {
    allowOther = true;
    directories = [
      "Documents"
    ];
  };

  # initial state version (do not change)
  home.stateVersion = "24.05";
}
