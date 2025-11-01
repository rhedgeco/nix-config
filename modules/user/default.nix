{iglib, ...}: {
  # import all modules in this directory
  imports = iglib.findModules ./.;

  # do not change unless necessary.
  # this marks the state version that this config was initially created with.
  # as home manager updates this is used to know what config items need to change.
  home.stateVersion = "24.05";
}
