{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    gedit # text editor
    loupe # image viewer
    alacritty # terminal
    nautilus # files
    baobab # disk usage analyzer
    gnome-calculator
    gnome-system-monitor
  ];
}
