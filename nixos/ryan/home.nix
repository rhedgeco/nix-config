{...}: {
  imports = [
    ./dconf/load.nix
    ./apps/all.nix
    ./persist.nix
    ./gnome.nix
    ./git.nix
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
