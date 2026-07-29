{inputs, ...}: {
  den.aspects.rust = {
    homeManager = {pkgs, ...}: {
      nixpkgs.overlays = [inputs.rust-overlay.overlays.default];
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
  };
}
