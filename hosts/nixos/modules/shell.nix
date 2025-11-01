{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  shell = config.myconfig.shell;
  impermanence = config.myconfig.impermanence;
  system = pkgs.stdenv.hostPlatform.system;
  yoink = inputs.yoink.packages.${system}.default;
in {
  options.myconfig.shell = {
    default = lib.mkOption {
      type = lib.types.package;
      default = pkgs.bash;
      description = "The default shell for the system.";
    };
  };

  config = {
    # add bash to the environment shells by default
    environment.shells = [pkgs.bash];

    # use the selected default shell for every user
    users.defaultUserShell = shell.default;

    # disable the sudo lecture
    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';

    # set the default environment editor to vim
    environment.variables.EDITOR = "vim";

    # include some shell tools by default with the system
    environment.systemPackages = with pkgs; [
      inotify-tools
      yoink
      python3
      direnv
      vim
      fd
      bat
    ];

    # persist users direnv state
    environment.persistence."/persist" = lib.mkIf impermanence.enable {
      users = lib.genAttrs impermanence.persistUsers (name: {
        directories = [
          # persist the direnv cache
          ".local/share/direnv"
        ];
      });
    };
  };
}
