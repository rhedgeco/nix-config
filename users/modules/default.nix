{lib, ...}: let
  # get all nix modules in the current directory.
  # this includes all folders by default
  # and files with a `.nix` extension
  # excluding `default.nix` to prevent recursion
  nixModules = lib.attrNames (
    lib.filterAttrs (
      name: type:
        type
        == "directory"
        || type
        == "regular"
        && name != "default.nix"
        && lib.strings.hasSuffix ".nix" name
    )
    (builtins.readDir ./.)
  );
in {
  # import all the nix modules in this directory.
  # this helps by importing every module without having to name each one.
  imports = lib.map (name: ./. + "/${name}") nixModules;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # do not change unless necessary.
  # this marks the state version that this config was initially created with.
  # as home manager updates this is used to know what config items need to change.
  home.stateVersion = "24.05";
}
