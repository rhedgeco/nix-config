{ inputs, ... }: {
  den.aspects.yoink.homeManager = { pkgs, ... }: {
    home.packages = [ inputs.yoink.packages.${pkgs.stdenv.hostPlatform.system}.yoink ];
  };
}
