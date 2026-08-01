{
  lib,
  den,
  ...
}:
{
  # define host option to set the system state version
  den.schema.host = {
    options.stateVersion = lib.mkOption {
      description = "set the state version for this host";
      type = with lib.types; nullOr str;
      default = null;
    };
  };

  # create an aspect that sets the default state version based on host schema
  den.aspects.set-state-version =
    { host, ... }:
    lib.optionalAttrs (host.stateVersion != null) {
      nixos.system.stateVersion = host.stateVersion;
      homeManager.home.stateVersion = lib.mkDefault host.stateVersion;
    };

  # include the set-state-version aspect by default
  den.default.includes = [ den.aspects.set-state-version ];
}
