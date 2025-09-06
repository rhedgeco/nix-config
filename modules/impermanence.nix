{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    (lib.mkIf config.custom.options.impermanence.enable inputs.impermanence.nixosModules.impermanence)
  ];

  options.custom.impermanence = {
    enable = lib.mkEnableOption "enable impermanence";

    persistDir = lib.mkOption {
      type = lib.types.str;
      description = "The path to be used for persisting impermanent files";
    };
  };

  config = lib.mkIf config.custom.impermanence.enable {
    # persist some system directories by default
    environment.persistence."${config.custom.impermanence.persistDir}" = {
      hideMounts = true;
      directories = [
        # system log files
        "/var/log"

        # needed for nixos systems
        "/var/lib/nixos"

        # systemd coredump info
        "/var/lib/systemd/coredump"
      ];
    };
  };
}
