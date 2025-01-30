{pkgs, ...}: {
  users.defaultUserShell = pkgs.fish;
  programs.command-not-found.enable = false;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    '';
  };

  environment = {
    shells = [pkgs.fish];
    variables.EDITOR = "vim";
  };
}
