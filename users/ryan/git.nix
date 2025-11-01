{pkgs, ...}: {
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
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/id_ed25519_github";
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
}
