{pkgs, ...}: {
  # add the bibita cursor
  environment.systemPackages = [
    pkgs.bibata-cursors
  ];
}
