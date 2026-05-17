{
  lib,
  den,
  inputs,
  ...
}: let
  apply = paths: config: lib.genAttrs paths (_: config);
in {
  # import flakeModule to generate top level flake structure
  imports = [inputs.den.flakeModule];

  # use home manager as a default class for all users
  den.schema.user.classes = lib.mkDefault ["homeManager"];

  # apply default settings across all classes
  # we use a merge strategy to combine different sets of settings together
  den.default = lib.mkMerge [
    {
      # Sets the system hostname from den.hosts.<name>.hostName. Works on NixOS and Darwin.
      includes = [den.batteries.hostname];

      # initial state versions for this configuration
      # these should not be changed unless you know what you are doing
      nixos.system.stateVersion = "24.05";
      homeManager.home.stateVersion = "24.05";
    }

    # apply duplicate settings to both nixos and home manager
    (apply ["nixos" "homeManager"] {
      # always allow unfree packages by default
      # i dont care enough to deal with that every time
      nixpkgs.config.allowUnfree = true;
      # sets the system 'nixpkgs' path to match the one used in this flake
      # this means when the <nixpkgs> syntax is used it will match system packages
      nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
      # automatically detects files in the store that have identical contents,
      # and replaces them with hard links to a single copy. This saves disk space.
      nix.settings.auto-optimise-store = true;
      # enables expetimental flakes and nix command features on this system by default
      # without this, many flake based commands would need `--extra-experimental-features flakes`
      nix.settings.experimental-features = ["nix-command" "flakes"];
    })
  ];
}
