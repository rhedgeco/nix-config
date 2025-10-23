{...}: {
  # create the niri config kdl file
  home.file.".config/niri/config.kdl" = {
    text = builtins.readFile ./config.kdl;
    force = true;
  };
}
