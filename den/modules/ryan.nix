{den, ...}: {
  den.aspects.ryan = {
    includes = [
      den.provides.primary-user
      (den.provides.user-shell "fish")
      den.aspects.discord
      den.aspects.embedded
      den.aspects.fish
      den.aspects.niri
      den.aspects.rust
    ];
  };
}
