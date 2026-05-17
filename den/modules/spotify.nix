{
  den.aspects.spotify = {
    homeManager = {pkgs, ...}: {
      home.packages = [pkgs.spotify];
      persist.directories = [".config/spotify"];
    };
  };
}
