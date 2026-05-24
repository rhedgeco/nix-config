{
  pkgs,
  iglib,
  ...
}:
iglib.module {
  name = "fishy";

  nixos = ctx: {
    always = {
      # enable the fish shell if any user has it enabled
      programs.fish.enable = ctx.users.anyEnabled;

      # set the fish shell as default for any users with fishy enabled
      users.users = ctx.users.genEnabled (name: {
        shell = pkgs.fish;
      });
    };
  };

  home.enabled = {
    # add some packages required by fishy
    home.packages = with pkgs; [
      grc # used by fish shell for colorizing
    ];

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

        # load direnv shell hook
        ${pkgs.devenv}/bin/devenv hook fish | source
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
}
