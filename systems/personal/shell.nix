{pkgs, ...}: {
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

  # diable command not found
  programs.command-not-found.enable = false;

  # set the default user shell to use fish
  users.defaultUserShell = pkgs.fish;

  environment = {
    # set the default environment shell to fish
    shells = [pkgs.fish];

    # set the default environment editor to vim
    variables.EDITOR = "vim";
  };

  # disable the sudo lecture
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  # include necessary packages for shell functionality
  environment.systemPackages = with pkgs; [
    # fancy shmancy rust based shell prompt
    starship

    # environment variable loader
    direnv

    # default terminal editor
    vim

    # run bash scripts easier in fish
    fishPlugins.bass

    # include python by default (required by bass)
    python3
  ];

  environment.persistence."/persist".users.ryan = {
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
}
