{
  pkgs,
  iglib,
  ...
}:
iglib.module {
  name = "fishy";

  nixos = ctx: {
    always = {
      # set the fish shell as default
      users.users = ctx.users.genEnabled (name: {
        shell = pkgs.fish;
      });
    };
  };

  home.enabled = {
    # enable and configure fish shell
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

    # ensure some data for fish shell is persisted between boots
    igloo.modules.persist.dirs = [
      # persist fish history
      # https://github.com/fish-shell/fish-shell/issues/10730
      # ^ prevents syncing only fish_history file
      ".local/share/fish"

      # persist the direnv cache
      # contains allow list, etc...
      ".local/share/direnv"
    ];
  };
}
