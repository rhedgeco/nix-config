{
  den.aspects.spotify = {
    homeManager = {pkgs, ...}: {
      home.packages = [pkgs.spotify];
      persist.dirs = [".config/spotify"];
    };
  };
}
