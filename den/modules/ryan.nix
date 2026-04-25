{den, ...}: {
  den.aspects.ryan = {
    includes = [
      den.provides.primary-user
      den.aspects.fishy-shell
    ];

    homeManager = {pkgs, ...}: {
      home.packages = [pkgs.htop];
    };
  };
}
