{ lib, mylib, ... }:
{
  # set up niri options to always exist
  den.default.homeManager.options.den.niri = {
    includes = lib.mkOption {
      description = "files to include in the niri config";
      type = lib.types.listOf (mylib.types.intoPath "custom.kdl");
      default = [ ];
    };
  };

  # configure niri when the aspect is included
  den.aspects.niri = {
    homeManager = { pkgs, config, ... }: {
      # include the niri package in the environment
      home.packages = with pkgs; [
        niri

        # niri does not have a built in x server
        # xwayland-satellite fills this gap
        # it hosts an xserver and simulates wayland clients
        xwayland-satellite
      ];

      den.niri.includes = [
        # include some default configuration with default priority
        (pkgs.writeText "rhedgeco-default.kdl" ''
          // rhedgeco's default niri configuration files
          ${lib.concatMapStringsSep "\n" (path: ''include "${./_assets/niri/${path}}"'') (
            builtins.attrNames (builtins.readDir ./_assets/niri)
          )}
        '')
      ];

      home.file = {
        ".config/niri/config.kdl".text = ''
          ${lib.concatMapStringsSep "\n" (path: ''include "${path}"'') config.den.niri.includes}
        '';
      };
    };
  };
}
