{
  lib,
  config,
  ...
}: {
  imports = [
    ./fish.nix
  ];

  options.custom.shell = {
    default = lib.mkOption {
      type = lib.types.enum ["fish"];
      description = "Select which shell to use.";
    };
  };

  config = {
    # ensure the default shell is automatically enabled
    custom.${config.custom.shell.default}.enable = true;

    # disable the sudo lecture
    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';

    # set the default environment editor to vim
    environment.variables.EDITOR = "vim";
    environment.systemPackages = [
      pkgs.vim
    ];
  };
}
