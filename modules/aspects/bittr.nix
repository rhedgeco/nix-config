{ ... }: {
  den.aspects.bittr.homeManager = { pkgs, ... }: {
    home.packages = with pkgs; [ qbittorrent-enhanced ];
  };
}
