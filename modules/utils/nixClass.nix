{
  lib,
  den,
  ...
}:
let
  # forwards `nix` class content into the `nix` options of the given class
  # `fromAspect` is the entity the class content was written on (host or user)
  forwardNix =
    intoClass: aspect-chain:
    den.batteries.forward {
      each = [ intoClass ];
      fromClass = _: "nix";
      intoClass = lib.id;
      intoPath = _: [ "nix" ];
      fromAspect = _: lib.head aspect-chain;
      adaptArgs = lib.id;
    };
in
{
  # a host forwards its own `nix` content into its os configuration
  den.aspects.nix-class-host = { host, aspect-chain, ... }: forwardNix host.class aspect-chain;

  # a user forwards its own `nix` content into its home configuration
  den.aspects.nix-class-user = { aspect-chain, ... }: forwardNix "homeManager" aspect-chain;

  den.schema.host.includes = [ den.aspects.nix-class-host ];
  den.schema.user.includes = [ den.aspects.nix-class-user ];
}
