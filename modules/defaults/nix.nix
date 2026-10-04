{ inputs, ... }: {
  den.default = {
    nix.settings = {
      # sets the nix packages path to match the one from this flake
      # when the <nixpkgs> syntax is used it will match the packages in this flake
      nix-path = [ "nixpkgs=${inputs.nixpkgs}" ];

      # enables expetimental flakes and nix command features on this system by default
      # without this, many flake based commands would need `--extra-experimental-features flakes`
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    # allow unfree packages by default
    # this allows installing packages that are not FOSS
    # while I prefer FOSS applications, this restriction can be frustrating
    nixpkgs.allowUnfree = true;
  };
}
