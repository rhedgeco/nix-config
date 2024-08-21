{...}: {
  # enable git with lfs
  programs.git = {
    enable = true;
    lfs.enable = true;
  };
}
