{
  den.default = {
    nixos = {pkgs, ...}: {
      # add bash to the environment shells by default
      environment.shells = [pkgs.bash];
      users.defaultUserShell = pkgs.bash;

      # disable the sudo lecture
      security.sudo.extraConfig = ''
        Defaults lecture = never
      '';

      # set the default environment editor to vim
      environment.variables.EDITOR = "vim";

      # include some packages globally by default
      environment.systemPackages = with pkgs; [
        bat
        fd
        ffmpeg
        gum
        inotify-tools
        just
        nano
        pciutils
        python3
        tree
        vim
      ];
    };
  };
}
