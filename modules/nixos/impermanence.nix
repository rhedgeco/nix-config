{
  lib,
  config,
  # inputs,
  ...
}: let
  impermanence = config.myconfig.impermanence;
in {
  imports = [
    # inputs.impermanence.nixosModules.impermanence
  ];

  options.myconfig.impermanence = {
    enable = lib.mkEnableOption "Enable impermanence.";

    persistUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "User home directories to persist.";
    };
  };

  config = lib.mkIf impermanence.enable {
    # allow non root users to fuse mount
    programs.fuse.userAllowOther = true;

    # # persist some system and user directories by default
    # environment.persistence."/persist" = {
    #   hideMounts = true;
    #   files = [
    #     "/etc/machine-id"
    #   ];
    #   directories = [
    #     # system log files
    #     "/var/log"

    #     # needed for nixos systems
    #     "/var/lib/nixos"

    #     # systemd coredump info
    #     "/var/lib/systemd/coredump"
    #   ];
    # };
  };
}
