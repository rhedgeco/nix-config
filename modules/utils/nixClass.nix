{
  lib,
  den,
  ...
}:
let
  # forwards nix content into both nixos and home manager
  nixClass =
    { aspect-chain, ... }:
    den.batteries.forward {
      each = [
        "nixos"
        "homeManager"
      ];
      fromClass = _: "nix";
      intoClass = lib.id;
      intoPath = _: [ "nix" ];
      fromAspect = _: lib.head aspect-chain;
      adaptArgs = lib.id;
    };
in
{
  # enable class for all users:
  den.schema.user.includes = [ nixClass ];
}
