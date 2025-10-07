{
  lib,
  inputs,
  ...
}: let
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

  # sets the nix packages path to match the one from this flake
  # this means when the <nixpkgs> syntax is used it will match the system packages
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  # allow unfree packages by default
  # this allows installing packages that are not FOSS
  # while I prefer FOSS applications, this restriction can be frustrating
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    # enables expetimental flakes and nix command features on this system by default
    # without this, many flake based commands would need `--extra-experimental-features flakes`
    experimental-features = ["nix-command" "flakes"];
    # automatically detects files in the store that have identical contents,
    # and replaces them with hard links to a single copy. This saves disk space.
    auto-optimise-store = true;
  };

  # do not change unless necessary.
  # this marks the state version that this config was created with.
  # as nixos updates this is used to know what config items need to change.
  system.stateVersion = "24.05";
}
