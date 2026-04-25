{
  den,
  inputs,
  ...
}: {
  imports = [inputs.den.flakeModule];

  den.default = {
    den.default.includes = [
      # Automatically sets the host’s name to the one defined in den.hosts.<name>.hostName. Works on NixOS/Darwin/WSL.
      den.provides.hostname
    ];

    nixos = {
      # sets the system 'nixpkgs' path to match the one used in this flake
      # this means when the <nixpkgs> syntax is used it will match system packages
      nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

      # automatically detects files in the store that have identical contents,
      # and replaces them with hard links to a single copy. This saves disk space.
      nix.settings.auto-optimise-store = true;

      # enables expetimental flakes and nix command features on this system by default
      # without this, many flake based commands would need `--extra-experimental-features flakes`
      nix.settings.experimental-features = ["nix-command" "flakes"];

      # defines the state version this system configuration was initially created with
      # changing this could invalidate assumtions about what different syntax and config options mean
      # only update this if you are confident you have fully migrated any older configuration
      system.stateVersion = "24.05";
    };
  };
}
