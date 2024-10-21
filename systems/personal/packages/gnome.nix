{pkgs, ...}: {
  # use gdm and gnome
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };

  # disable all gnome packages
  services.xserver.excludePackages = [pkgs.xterm];
  services.gnome.core-utilities.enable = false;
  environment.gnome.excludePackages = with pkgs; [
    gnome.gnome-shell-extensions
    gnome-tour
  ];

  # add back in some gnome packages
  environment.systemPackages = with pkgs; [
    gedit # text editor
    loupe # image viewer
    contrast # color picker
    gnome.nautilus # files
    gnome.baobab # disk usage analyzer
    gnome.gnome-tweaks
    gnome.gnome-terminal
    gnome.gnome-calculator
    gnome.gnome-screenshot
    gnome.gnome-system-monitor
  ];
}
