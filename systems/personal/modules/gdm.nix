{...}: {
  # use gdm without gnome
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
  };
}
