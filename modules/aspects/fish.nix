{
  den.aspects.fish.homeManager = {pkgs, ...}: {
    # persist fish history
    # https://github.com/fish-shell/fish-shell/issues/10730
    # ^ prevents syncing only fish_history file
    persist.dirs = [".local/share/fish"];

    home.packages = [
      pkgs.grc # used by fish shell for colorizing
    ];

    programs.fish = {
      enable = true;

      # disable the shell greeting by default
      interactiveShellInit = ''
        # disable the fish greeting
        set fish_greeting
      '';

      # include some useful plugins by default with fish
      plugins = [
        # GRC: command colorizer
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }

        # BASS: allows running bash scripts/commands easier
        {
          name = "bass";
          src = pkgs.fishPlugins.bass.src;
        }
      ];
    };
  };
}
