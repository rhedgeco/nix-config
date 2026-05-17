{den, ...}: {
  den.aspects.ryan = {
    includes = [
      # make ryan always a primary user
      den.batteries.primary-user

      # use fish shell
      (den.batteries.user-shell "fish")
      den.aspects.fish

      # development tools
      den.aspects.devenv
      den.aspects.direnv
      den.aspects.rust

      # other tools and apps
      den.aspects.discord
    ];
  };
}
