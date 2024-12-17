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
      format = ''
        [╭─](bold green) $directory$git_branch$rust
        [╰](bold green)$character
      '';

      package.disabled = true;
    };
  };
}
