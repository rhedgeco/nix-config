{config, ...}: let
  dconf_db = "${config.home.homeDirectory}/.config/dconf/user";
in {
  home.activation = {
    loadDconf = ''
      dconf compile ${dconf_db} ${./keyfiles}
    '';
  };
}
