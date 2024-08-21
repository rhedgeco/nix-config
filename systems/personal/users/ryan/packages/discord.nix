{pkgs, ...}: {
  home.packages = [
    pkgs.discord
  ];

  # persist discord data
  home.persistence."/persist/home/ryan" = {
    allowOther = true;
    directories = [
      ".config/discord"
    ];
  };
}
