{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [inputs.rust-overlay.overlays.default];
  home.packages = with pkgs; [
    rust-bin.stable.latest.default
  ];
}
