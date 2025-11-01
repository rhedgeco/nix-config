{...}: {
  # if there exists a file where home manager is trying to make a symlink
  # instead of failing it will backup the old file with the "*.backup" extension.
  home-manager.backupFileExtension = "backup";
}
