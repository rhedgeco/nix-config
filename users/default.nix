{
  buildHome = {
    name,
    config ? {},
  }: {iglib, ...}: {
    imports =
      # import all global user modules
      iglib.getModulePaths ./modules
      # import all modules from the user directory
      ++ iglib.getModulePaths (./. + "/${name}")
      # and import all the custom user config
      ++ [({...}: {inherit config;})];

    # set every users name to match their directory
    home.username = "${name}";

    # set each users home directory to the standard path
    home.homeDirectory = "/home/${name}";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # do not change unless necessary.
    # this marks the state version that this config was initially created with.
    # as home manager updates this is used to know what config items need to change.
    home.stateVersion = "24.05";
  };
}
