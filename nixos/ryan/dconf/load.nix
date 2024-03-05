{
  config,
  pkgs,
  ...
}: let
  dconf_dir = "${config.home.homeDirectory}/.config/dconf";
in {
  home.activation = {
    # compiles all keyfiles into the user database
    loadDconf = ''
      mkdir -p ${dconf_dir}
      ${pkgs.dconf}/bin/dconf compile ${dconf_dir}/user ${./keyfiles}
    '';
  };
}
