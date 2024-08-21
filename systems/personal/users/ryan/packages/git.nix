{...}: {
  home.file.".ssh/allowed_signers".text = "* ${builtins.readFile /home/ryan/.ssh/id_ed25519.pub}";

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "rhedgeco";
    userEmail = "rhedgeco@gmail.com";

    extraConfig = {
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };
  };
}
