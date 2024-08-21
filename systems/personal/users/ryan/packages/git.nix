{...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "rhedgeco";
    userEmail = "rhedgeco@gmail.com";

    extraConfig = {
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };
  };
}
