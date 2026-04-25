{den, ...}: {
  den.aspects.fish = {
    includes = [
      den.aspects.direnv
    ];

    persist-home.directories = [
      # persist fish history
      # https://github.com/fish-shell/fish-shell/issues/10730
      # ^ prevents syncing only fish_history file
      ".local/share/fish"
    ];

    homeManager = {pkgs, ...}: {
      programs.fish = {
        enable = true;

        interactiveShellInit = ''
          # disable the fish greeting
          set fish_greeting

          # load starship shell hook
          ${pkgs.starship}/bin/starship init fish | source

          # load direnv shell hook
          ${pkgs.direnv}/bin/direnv hook fish | source
        '';

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
  };
}
