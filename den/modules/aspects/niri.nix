{
  den.aspects.niri = {
    homeManager = {pkgs, ...}: let
      # nixpkgs bumped the libdisplay-info C library to 0.4.0, but niri's vendored
      # `libdisplay-info-sys 0.3.0` crate requires `libdisplay-info < 0.4.0`, so the
      # stock niri fails to build. Pin the older 0.3.0 library just for niri until
      # nixpkgs ships a compatible pair.
      libdisplay-info' = pkgs.libdisplay-info.overrideAttrs (_: rec {
        version = "0.3.0";
        src = pkgs.fetchFromGitLab {
          domain = "gitlab.freedesktop.org";
          owner = "emersion";
          repo = "libdisplay-info";
          rev = version;
          hash = "sha256-nXf2KGovNKvcchlHlzKBkAOeySMJXgxMpbi5z9gLrdc=";
        };
      });

      niri' = pkgs.niri.override {libdisplay-info = libdisplay-info';};
    in {
      home.packages = [niri'];
    };
  };
}
