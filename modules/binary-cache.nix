{iglib, ...}:
iglib.module {
  name = "binary-cache";
  enabled = true;

  nixos.enabled.nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.garnix.io"
      "https://zed.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
    ];
  };
}
