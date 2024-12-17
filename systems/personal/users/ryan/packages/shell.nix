{
  config,
  pkgs,
  ...
}: {
  # include useful packages
  home.packages = with pkgs; [
    grc
  ];

  # configure fish shell
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      {
        name = "done";
        src = pkgs.fishPlugins.done;
      }
      {
        name = "grc";
        src = pkgs.fishPlugins.grc;
      }
    ];
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
