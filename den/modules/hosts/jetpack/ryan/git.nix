{
  den.aspects.jetpack.provides.ryan.homeManager = {pkgs, ...}: {
    # set up the gpg agent
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-gnome3;
    };

    # set up ssh key for github.com
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "github-personal" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/id_ed25519_personal";
          identitiesOnly = true;
        };
        "github-ford" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/id_ed25519_ford";
          identitiesOnly = true;
        };
      };
    };

    # configure git
    programs.git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user.name = "Ryan Hedgecock";
        user.email = "rhedgeco@gmail.com";
        init.defaultBranch = "main";
      };

      # enable GPG signing
      signing.signByDefault = true;
    };

    # persist `.ssh` `.gnupg` and `keyring` directories
    persist.dirs = [
      {
        directory = ".ssh";
        mode = "0700";
      }
      {
        directory = ".gnupg";
        mode = "0700";
      }
      {
        directory = ".local/share/keyrings";
        mode = "0700";
      }
    ];
  };
}
