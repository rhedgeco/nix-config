{...}: {
  # import packages
  imports = [
    "${inputs.impermanence}/home-manager.nix"
    ./packages
  ];

  # set home data
  home = {
    username = "ryan";
    homeDirectory = "/home/ryan";
  };

  # allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # enable home-manager
  programs.home-manager.enable = true;

  # state version
  home.stateVersion = "24.05";
}
