{ lib, ... }:
let
  settingsBuilder = with lib.types; coercedTo str (s: builtins.toFile "custom.kdl" s) path;
in
{
  den.aspects.niri = {
    homeManager = { pkgs, config, ... }: {
      options.den.niri = {
        includes = lib.mkOption {
          description = "files to include in the niri config";
          type = lib.types.listOf settingsBuilder;
          default = [ ];
        };
      };

      config = {
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
  };
}
