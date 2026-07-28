{
  # any packages that can be defined just by including
  den.aspects.jetpack.provides.ryan.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      nautilus
    ];
  };
}
