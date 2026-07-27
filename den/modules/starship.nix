{
  den.aspects.starship.homeManager = {pkgs, ...}: {
    programs.fish.interactiveShellInit = ''
      # load starship shell hook
      ${pkgs.starship}/bin/starship init fish | source
    '';
  };
}
