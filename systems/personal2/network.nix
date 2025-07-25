{...}: {
  # enable NetworkManager
  networking.networkmanager.enable = true;

  # persist NetworkManager connections
  environment.persistence."/persist" = {
    directories = [
      "/etc/NetworkManager/system-connections"
    ];
  };
}
