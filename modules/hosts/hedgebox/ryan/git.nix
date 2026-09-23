{
  den.aspects.hedgebox.provides.ryan.homeManager = { pkgs, ... }: {
    # set up the gpg agent
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-gnome3;
    };

    # include git and git-lfs
    home.packages = with pkgs; [
      git
      git-lfs
    ];

    # persist `.ssh` `.gnupg` directories
    persist.dirs = [
      ".config/git"
      {
        directory = ".ssh";
        mode = "0700";
      }
      {
        directory = ".gnupg";
        mode = "0700";
      }
    ];
  };
}
