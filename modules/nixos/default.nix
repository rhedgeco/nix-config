{
  iglib,
  inputs,
  ...
}:
iglib.module {
  name = "legacy-nixos-modules";
  nixos = {
    # import all modules in this directory
    imports = iglib.findModules ./.;

    # sets the nix packages path to match the one from this flake
    # this means when the <nixpkgs> syntax is used it will match the system packages
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    # allow unfree packages by default
    # this allows installing packages that are not FOSS
    # while I prefer FOSS applications, this restriction can be frustrating
    nixpkgs.config.allowUnfree = true;

    # enables expetimental flakes and nix command features on this system by default
    # without this, many flake based commands would need `--extra-experimental-features flakes`
    nix.settings.experimental-features = ["nix-command" "flakes"];

    # automatically detects files in the store that have identical contents,
    # and replaces them with hard links to a single copy. This saves disk space.
    nix.settings.auto-optimise-store = true;

    # do not change unless necessary.
    # this marks the state version that this config was initially created with.
    # as nixos updates this is used to know what config items need to change.
    system.stateVersion = "24.05";
  };
}
