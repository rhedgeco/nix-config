{iglib, ...}: {
  # import all modules in this directory
  imports = iglib.collectNixFiles ./.;
}
