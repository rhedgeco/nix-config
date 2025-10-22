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
  impermanence = config.custom.impermanence;
in {
  # import the impermanence home manager module for all users
  imports = [inputs.impermanence.homeManagerModules.default];

  # set up options to enable impermanence for all users
  options.custom.impermanence = {
    enable = lib.mkEnableOption "Enables impermanence storage for ${user.name}";
    userDir = lib.mkOption {
      type = lib.types.str;
      description = "The users persistent storage location.";
    };
  };

  # allow other on the user directory if enabled
  config = lib.mkIf impermanence.enable {
    home.persistence."${impermanence.userDir}" = {
      allowOther = true;
    };
  };
}
