{pkgs, ...}: {
  home.packages = with pkgs; [
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.launch-new-instance
    gnomeExtensions.removable-drive-menu
    gnomeExtensions.system-monitor-next
    gnomeExtensions.just-perfection
    gnomeExtensions.user-themes
    gnomeExtensions.paperwm
  ];
}
