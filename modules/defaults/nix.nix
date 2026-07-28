{inputs, ...}: {
  den.default = {
    # enables expetimental flakes and nix command features on this system by default
    # without this, many flake based commands would need `--extra-experimental-features flakes`
    nix.settings.experimental-features = ["nix-command" "flakes"];

    # sets the nix packages path to match the one from this flake
    # when the <nixpkgs> syntax is used it will match the packages in this flake
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    # allow unfree packages by default
    # this allows installing packages that are not FOSS
    # while I prefer FOSS applications, this restriction can be frustrating
    nixpkgs.allowUnfree = true;
  };
}
