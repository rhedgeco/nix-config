{
  lib,
  config,
  inputs,
  ...
}: let
  user = {
    name = config.home.username;
    home = config.home.homeDirectory;
  };
in {
  # import the impermanence home manager module for all users
  imports = [inputs.impermanence.homeManagerModules.default];

  # set up options to enable impermanence for all users
  options.myconfig.impermanence = {
    enable = lib.mkEnableOption "Enables impermanence storage for ${user.name}";
    userDir = lib.mkOption {
      type = lib.types.str;
      description = "The users persistent storage location.";
    };
  };
}
