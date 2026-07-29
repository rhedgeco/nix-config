{
  den.default.nixos = {
    # automatically detects files in the store that have identical contents,
    # and replaces them with hard links to a single copy. This saves disk space.
    nix.settings.auto-optimise-store = true;
  };
}
