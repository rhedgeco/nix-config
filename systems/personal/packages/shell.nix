{pkgs, ...}: {
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  environment = {
    shells = [pkgs.fish];
    variables.EDITOR = "vim";
  };
}
