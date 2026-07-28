{lib, ...}: {
  den.default.nixos = {host, ...}: {
    networking.hostName = lib.mkDefault host.name;
  };
}
