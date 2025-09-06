{
  lib,
  config,
  ...
}: {
  options.custom.rust = {
    enable = lib.mkEnableOption "Enable rust";
  };

  config = lib.mkIf config.custom.rust.enable {
    environment.systemPackages = with pkgs; [
      rustup
      gcc
    ];

    environment.persistence = lib.mkIf config.custom.impermanence.enable {
      ${config.custom.impermanence.persistDir}.users = {
        ryan = lib.mkIf config.custom.users.ryan.enable {
          directories = [
            ".rustup"
          ];
        };
      };
    };
  };
}
