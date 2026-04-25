{
  pkgs,
  inputs,
  iglib,
  ...
}: let
  noctalia-pkg = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
  noctalia-shell = "${noctalia-pkg}/bin/noctalia-shell";
in
  iglib.module {
    name = "noctalia";

    home = {
      enabled = {
        home.packages = [
          inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      };
    };
  }
