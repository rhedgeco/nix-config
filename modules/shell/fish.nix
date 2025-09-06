{
  lib,
  config,
  ...
}: {
  options.custom.fish = {
    enable = lib.mkEnableOption "Enable fish shell";
  };

  config = lib.mkIf config.custom.fish.enable {
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

    environment.shells = [pkgs.fish];
    programs.command-not-found.enable = false;
    users.defaultUserShell = lib.mkIf (config.custom.shell.default == "fish") pkgs.fish;

    environment.persistence = lib.mkIf config.custom.impermanence.enable {
      ${config.custom.impermanence.persistDir}.users = {
        ryan = lib.mkIf config.custom.users.ryan.enable {
          files = [
          ];
          directories = [
            # persist the direnv cache
            ".local/share/direnv"

            # persist fish history
            # https://github.com/fish-shell/fish-shell/issues/10730
            # ^ prevents syncing only fish_history file
            ".local/share/fish"
          ];
        };
      };
    };
  };
}
