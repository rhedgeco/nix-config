{pkgs, ...}: {
  home.packages = with pkgs; [
    mpv # video player
    gedit # text editor
    loupe # image viewer
    nautilus # files
    baobab # disk usage analyzer
    gnome-calculator
    gnome-screenshot
    gnome-system-monitor
  ];
}