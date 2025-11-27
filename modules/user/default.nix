{iglib, ...}:
iglib.module {
  name = "legacy-user-modules";
  # import all modules in this directory
  home.imports = iglib.collectNixFiles ./.;
}
