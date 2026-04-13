{den, ...}: {
  den.aspects.ryan = {
    includes = [
      den.provides.primary-user
      (den.provides.user-shell "fish")
    ];

    homeManager = {pkgs, ...}: {
      home.packages = [pkgs.htop];
    };
  };
}
