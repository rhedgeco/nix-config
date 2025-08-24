{lib, ...}: {
  # set los angeles as the default time zone for all systems
  time.timeZone = lib.mkDefault "America/Los_Angeles";
}
