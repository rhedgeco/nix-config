{ den, ... }: {
  # alias fishy as a collection of shell aspects
  den.aspects.fishy.includes = [
    (den.batteries.user-shell "fish")
    den.aspects.fish
    den.aspects.starship
    den.aspects.direnv
    den.aspects.devenv
  ];
}
