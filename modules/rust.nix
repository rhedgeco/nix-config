{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  rust = config.myconfig.rust;
in {
  options.myconfig.rust = {
    enable = lib.mkEnableOption "Enable rust development binaries";
  };

  config = lib.mkIf rust.enable {
    # apply the rust overlay
    nixpkgs.overlays = [inputs.rust-overlay.overlays.default];

    # add the rust binaries to the system environment
    environment.systemPackages = [
      (pkgs.rust-bin.stable.latest.minimal.override {
        extensions = [
          "rustc"
          "cargo"
          "rustfmt"
          "rust-std"
          "rust-src"
          "rust-docs"
          "rust-analyzer"
          "clippy"
        ];
      })
    ];
  };
}
