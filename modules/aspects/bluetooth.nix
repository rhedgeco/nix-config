{ ... }: {
  den.aspects.bluetooth.nixos = { ... }: {
    # enable bluetooth for the system
    hardware.bluetooth.enable = true;

    # persist the bluetooth connections
    persist.dirs = [ "/var/lib/bluetooth" ];
  };
}
