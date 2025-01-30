{pkgs, ...}: {
  users.defaultUserShell = pkgs.fish;
  programs.command-not-found.enable = false;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
  };

  environment = {
    shells = [pkgs.fish];
    variables.EDITOR = "vim";
  };
}
