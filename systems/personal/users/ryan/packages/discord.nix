{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    pkgs.discord
  ];

  # persist discord data
  home.persistence."/persist${config.home.homeDirectory}" = {
    allowOther = true;
    directories = [
      ".config/discord"
    ];
  };
}
