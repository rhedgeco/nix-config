{
  den.aspects.minicom = {
    # any user with this aspect should have dialout access
    user.extraGroups = [ "dialout" ];

    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        minicom
      ];
    };
  };
}
