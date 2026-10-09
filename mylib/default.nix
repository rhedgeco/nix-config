inputs:
let
  args = {
    inherit mylib inputs;
    lib = inputs.nixpkgs.lib;
  };

  mylib = {
    den = import ./den.nix args;
    types = import ./types.nix args;
  };
in
mylib
