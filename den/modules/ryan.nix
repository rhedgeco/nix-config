{den, ...}: {
  den.aspects.ryan = {
    includes = [
      den.provides.primary-user
      (den.provides.user-shell "fish")
      den.aspects.fish
      den.aspects.niri
      den.aspects.discord
    ];
  };
}
