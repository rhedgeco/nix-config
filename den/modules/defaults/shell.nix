{
  den.default.nixos = {pkgs, ...}: {
    # add bash to the environment shells by default
    environment.shells = [pkgs.bash];
    users.defaultUserShell = pkgs.bash;

    # disable the sudo lecture
    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';
  };
}
