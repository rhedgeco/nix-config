{pkgs, ...}: {
  # enable bluetooth and NetworkManager
  hardware.bluetooth.enable = true;
  networking.networkmanager.enable = true;

  # enable the blueman bluetooth service
  services.blueman.enable = true;

  # include system packages to control network
  environment.systemPackages = with pkgs; [
    networkmanagerapplet # network manager app
  ];

  # allow ryan to nodify network settings
  users.users.ryan.extraGroups = [
    "networkmanager"
  ];

  # persist NetworkManager connections
  environment.persistence."/persist" = {
    directories = [
      "/etc/NetworkManager/system-connections"
    ];
  };
}
