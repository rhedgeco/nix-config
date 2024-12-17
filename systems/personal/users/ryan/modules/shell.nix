{
  config,
  pkgs,
  ...
}: {
  # configure fish shell
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
  };

  # enable starship
  programs.starship = {
    enable = true;
    settings = {
      # disable package display
      package.disabled = true;
    };
  };
}
