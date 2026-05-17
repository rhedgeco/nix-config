{
  den.aspects.fish = {
    homeManager = {pkgs, ...}: {
      persist.directories = [
        # persist fish history
        # cannot persist only fish_history due to issue here
        # https://github.com/fish-shell/fish-shell/issues/10730
        ".local/share/fish"
      ];

      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          # disable the fish greeting
          set fish_greeting

          # load starship shell hook
          ${pkgs.starship}/bin/starship init fish | source
        '';

        # include some fish plugins by default
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
