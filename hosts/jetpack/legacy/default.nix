{iglib, ...}:
iglib.module {
  name = "legacy-jetpack-modules";
  enabled = true; # enabled by default
  nixos = {
    # import all modules in this directory
    imports = iglib.findModules ./.;
  };
}
