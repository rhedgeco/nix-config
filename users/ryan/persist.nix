{...}: {
  # persist some common user data directories
  igloo.modules.persist.dirs = [
    "Downloads"
    "Music"
    "Pictures"
    "Documents"
    "Videos"
    ".local/state/wireplumber"
  ];
}
