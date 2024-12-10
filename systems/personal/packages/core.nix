{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    gedit # text editor
    loupe # image viewer
    alacritty # terminal
    gnome.nautilus # files
    gnome.baobab # disk usage analyzer
    gnome.gnome-calculator
    gnome.gnome-system-monitor
  ];
}
