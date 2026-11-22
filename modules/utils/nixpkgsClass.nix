{
  lib,
  den,
  ...
}:
let
  # forwards `nixpkgs` class content into the `nixpkgs.config` options of the given class
  # `fromAspect` is the entity the class content was written on (host or user)
  forwardNixpkgs =
    intoClass: aspect-chain:
    den.batteries.forward {
      each = [ intoClass ];
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
  # a host forwards its own `nixpkgs` content into its os configuration
  den.aspects.nixpkgs-class-host =
    { host, aspect-chain, ... }: forwardNixpkgs host.class aspect-chain;

  # a user forwards its own `nixpkgs` content into its home configuration
  den.aspects.nixpkgs-class-user = { aspect-chain, ... }: forwardNixpkgs "homeManager" aspect-chain;

  den.schema.host.includes = [ den.aspects.nixpkgs-class-host ];
  den.schema.user.includes = [ den.aspects.nixpkgs-class-user ];
}
