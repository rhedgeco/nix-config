{lib, ...}: {
  # import all nix hosts in this directory
  imports = lib.custom.read.nixPaths ./.;
}
