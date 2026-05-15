{
  den.aspects.jetpack.persist-nixos = {
    files = [
      "/etc/machine-id"
    ];
    directories = [
      "/var/log" # system log files
      "/var/lib/nixos" # needed for nixos systems
      "/var/lib/systemd/coredump" # systemd coredump info
    ];
  };
}
