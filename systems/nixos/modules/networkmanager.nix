{
  lib,
  config,
  ...
}: let
  networkmanager = config.myconfig.networkmanager;
  impermanence = config.myconfig.impermanence;
in {
  options.myconfig.networkmanager = {
    enable = lib.mkEnableOption "Enable network manager";
    powersave = lib.mkEnableOption "Enable networkmanager power saving";
    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Users allowed to configure the network";
    };
  };

  config = lib.mkIf networkmanager.enable {
    # enable network manager
    networking.networkmanager.enable = true;

    # add the networkmanager group to specified users
    users.users = lib.genAttrs impermanence.persistUsers (name: {
      extraGroups = ["networkmanager"];
    });

    # Configure DNS servers
    networking.nameservers = [
      # cloudflare
      "1.1.1.1"
      "1.0.0.1"
      # google
      "8.8.8.8"
      "8.8.4.4"
    ];

    # enable networkmanager powersaving if configured
    networking.networkmanager.wifi.powersave = networkmanager.powersave;

    # persist the system connections if impermanence is enabled
    environment.persistence."/persist" = lib.mkIf impermanence.enable {
      directories = [
        "/etc/NetworkManager/system-connections"
      ];
    };
  };
}
