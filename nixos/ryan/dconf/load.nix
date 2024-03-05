{
  config,
  pkgs,
  ...
}: let
  dconf_db = "${config.home.homeDirectory}/.config/dconf/user";
in {
  home.activation = {
    # compiles all keyfiles into the user database
    loadDconf = "${pkgs.dconf}/bin/dconf compile ${dconf_db} ${./keyfiles}";
  };
}
