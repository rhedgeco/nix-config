{den, ...}: {
  den.aspects.ryan = {
    includes = [
      # make ryan always a primary user
      den.batteries.primary-user

      # use fish shell
      (den.batteries.user-shell "fish")
      den.aspects.fish

      # software dev tools
      den.aspects.devenv
      den.aspects.direnv
      den.aspects.docker
      den.aspects.embedded
      den.aspects.rust
      den.aspects.zed

      # other tools and apps
      den.aspects.color-picker
      den.aspects.discord
      den.aspects.printing-3d
      den.aspects.spotify
    ];
  };
}
