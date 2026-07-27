{
  # include some base cli tools on every system
  den.default = {
    extraPackages = {pkgs, ...}:
      with pkgs; [
        bat
        vim
        nano
        direnv
        fd
        iw
        jq
        gum
        tree
        inotify-tools
        just
        python3
        pciutils
        ffmpeg
      ];
  };
}
