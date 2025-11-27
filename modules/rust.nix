{
  pkgs,
  iglib,
  inputs,
  ...
}:
iglib.module {
  name = "rust";

  # apply overlays at the nixos level
  nixos.always = {
    nixpkgs.overlays = [
      inputs.rust-overlay.overlays.default
      inputs.nix-vscode-extensions.overlays.default
    ];
  };

  home.enabled = {
    # include rust tools and binaries in user packages
    home.packages = with pkgs; [
      gcc # include gcc for linking
      cargo-expand
      (rust-bin.stable.latest.minimal.override {
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
