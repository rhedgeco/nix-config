{iglib, ...}:
iglib.module {
  name = "legacy-jetpack-modules";
  nixos = {
    # import all modules in this directory
    imports = iglib.findModules ./.;
  };
}
