{inputs, ...}: {
  # enable homeManager by default for all users
  den.schema.user.classes = ["homeManager"];

  den.default.homeManager = {
    # enables expetimental flakes and nix command features on this system by default
    # without this, many flake based commands would need `--extra-experimental-features flakes`
    nix.settings.experimental-features = ["nix-command" "flakes"];

    # automatically detects files in the store that have identical contents,
    # and replaces them with hard links to a single copy. This saves disk space.
    nix.settings.auto-optimise-store = true;

    # sets the nix packages path to match the one from this flake
    # when the <nixpkgs> syntax is used it will match the packages in this flake
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    # allow unfree packages by default
    # this allows installing packages that are not FOSS
    # while I prefer FOSS applications, this restriction can be frustrating
    nixpkgs.config.allowUnfree = true;
  };
}
