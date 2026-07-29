{
  den.aspects.network = {
    # any user that needs to use the network needs to be in this group
    user.extraGroups = ["networkmanager"];

    nixos = {
      networking.networkmanager.enable = true;

      networking.nameservers = [
        # cloudflare
        "1.1.1.1"
        "1.0.0.1"

        # google
        "8.8.8.8"
        "8.8.4.4"
      ];

      persist.dirs = [
        # persist the network manager connections between boots
        # so you dont have to re-authenticate your wifi each time
        "/etc/NetworkManager/system-connections"
      ];
    };
  };
}
