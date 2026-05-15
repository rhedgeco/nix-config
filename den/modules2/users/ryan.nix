{den, ...}: {
  # users are defined just like any other aspect
  # and when a host adds `users.ryan = {}` to its config
  # this user aspect will be automatically pulled in
  den.aspects.ryan = {
    includes = [
      # ryan is always a primary user on any system
      den.batteries.primary-user

      # use fish shell as primary shell
      (den.batteries.user-shell "fish")
      den.aspects.fish

      # development tools
      den.aspects.devenv
      den.aspects.direnv
      den.aspects.rust

      # other tools
      den.aspects.discord
    ];
  };
}
