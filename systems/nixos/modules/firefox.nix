{
  lib,
  pkgs,
  config,
  ...
}: let
  firefox = config.myconfig.firefox;
  impermanence = config.myconfig.impermanence;
in {
  options.myconfig.firefox = {
    enable = lib.mkEnableOption "Enable firefox";
  };

  config = lib.mkIf firefox.enable {
    # add the firefox package
    environment.systemPackages = [
      pkgs.firefox
    ];

    # use firefox as default mime type for PDFs
    xdg.mime = {
      defaultApplications = {
        "application/pdf" = "firefox.desktop";
      };
    };

    # persist users firefox directories
    environment.persistence."/persist" = lib.mkIf impermanence.enable {
      users = lib.genAttrs impermanence.persistUsers (name: {
        directories = [
          ".mozilla"
        ];
      });
    };
  };
}
