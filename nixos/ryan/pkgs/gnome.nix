{pkgs, ...}: {
  home.packages = with pkgs; [
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.launch-new-instance
    gnomeExtensions.removable-drive-menu
    gnomeExtensions.system-monitor-next
    gnomeExtensions.just-perfection
    gnomeExtensions.user-themes
    gnomeExtensions.paperwm

    (vimix-icon-theme.override {
      colorVariants = ["Beryl"];
    })

    (orchis-theme.override
      {
        border-radius = 6;
        tweaks = ["macos" "submenu"];
      })
  ];
}
