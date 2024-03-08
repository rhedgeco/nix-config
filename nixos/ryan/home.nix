{inputs, ...}: {
  imports = [
    "${inputs.impermanence}/home-manager.nix"
    ./dconf/load.nix
    ./pkgs/all.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "ryan";
    homeDirectory = "/home/ryan";
  };

  systemd.user.startServices = "sd-switch";
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
