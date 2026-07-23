{lib, ...}: {
  # define host option to set the system state version
  den.schema.host = {
    options.stateVersion = lib.mkOption {
      description = "set the state version for this host";
      type = with lib.types; nullOr str;
      default = null;
    };
  };

  # pass the host state version down to the contexts that use it
  den.default.includes = [
    ({host, ...}:
      lib.optionalAttrs (host.stateVersion != null) {
        nixos.system.stateVersion = lib.mkDefault host.stateVersion;
        homeManage.home.stateVersion = lib.mkDefault host.stateVersion;
      })
  ];
}
