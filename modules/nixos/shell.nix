{pkgs, ...}: {
  config = {
    # add bash to the environment shells by default
    environment.shells = [pkgs.bash];
    users.defaultUserShell = pkgs.bash;

    # disable the sudo lecture
    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';

    # set the default environment editor to vim
    environment.variables.EDITOR = "vim";
  };
}
