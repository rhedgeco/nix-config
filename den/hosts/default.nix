{lib, ...}: {
  imports = lib.custom.read.nixModulePaths ./.;
}
