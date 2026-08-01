{
  lib,
  den,
  ...
}:
let
  # forwards nix content into both nixos and home manager
  nixpkgsClass =
    { aspect-chain, ... }:
    den.batteries.forward {
      each = [
        "nixos"
        "homeManager"
      ];
      fromClass = _: "nixpkgs";
      intoClass = lib.id;
      intoPath = _: [
        "nixpkgs"
        "config"
      ];
      fromAspect = _: lib.head aspect-chain;
      adaptArgs = lib.id;
    };
in
{
  # enable class for all users:
  den.schema.user.includes = [ nixpkgsClass ];
}
