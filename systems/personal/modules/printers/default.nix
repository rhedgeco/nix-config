{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (callPackage ./mfcj480dw.nix {})
  ];
}
