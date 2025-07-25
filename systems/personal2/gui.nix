{pkgs, ...}: {
  # use lightdm as display manager
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
  };

  # enable the niri window manager
  programs.niri.enable = true;

  environment.systemPackages = [
    # niri expects alacritty as its default terminal
    pkgs.alacritty

    # niri expects fuzzel as its default app launcher
    pkgs.fuzzel

    # niri starts up waybar when it is launched
    pkgs.waybar
  ];
}
