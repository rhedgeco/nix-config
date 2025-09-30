{
  lib,
  pkgs,
  config,
  ...
}: let
  fish = config.myconfig.shell.fish;
  impermanence = config.myconfig.impermanence;
in {
  options.myconfig.shell.fish = {
    enable = lib.mkEnableOption "Enable the fish shell.";
    setDefault = lib.mkOption {
      type = lib.types.bool;
      description = "Use fish shell as the default shell.";
    };
  };

  config = lib.mkIf fish.enable {
    # set the shell as default if specified
    myconfig.shell.default = lib.mkIf fish.setDefault pkgs.fish;

    # disable command-not-found as it seems to cause problems
    programs.command-not-found.enable = false;

    # add fish shell to the environment shells
    environment.shells = [pkgs.fish];

    environment.systemPackages = with pkgs; [
      fishPlugins.bass
      fishPlugins.grc
      python3
      grc
    ];

    # enable the fish shell
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
    };

    # persist users fish state
    environment.persistence."/persist" = lib.mkIf impermanence.enable {
      users = lib.genAttrs impermanence.persistUsers (name: {
        directories = [
          # persist fish history
          # https://github.com/fish-shell/fish-shell/issues/10730
          # ^ prevents syncing only fish_history file
          ".local/share/fish"
        ];
      });
    };
  };
}
