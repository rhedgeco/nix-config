{iglib, ...}:
iglib.module {
  name = "legacy-nixos-modules";
  # import all modules in this directory
  nixos.imports = iglib.collectNixFiles ./.;
}
