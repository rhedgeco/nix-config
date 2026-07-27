{
  den.aspects.niri = {
    homeManager = {pkgs, ...}: {
      home.packages = [pkgs.niri];
    };
  };
}
