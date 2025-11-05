{iglib, ...}:
iglib.module {
  name = "legacy-jetpack-modules";
  nixosModule = {
    # import all modules in this directory
    imports = iglib.findModules ./.;
  };
}
