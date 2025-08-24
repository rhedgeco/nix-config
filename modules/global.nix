{...}: {
  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # enable flakes
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };

  # do not change (unless you know what you are doing)
  system.stateVersion = "24.05";
}
