{
  den,
  inputs,
  ...
}: {
  imports = [inputs.den.flakeModule];

  den.default = {
    den.default.includes = [
      # Sets the system hostname as defined in den.hosts.<name>.hostName
      den.provides.hostname
    ];

    homeManager = {
      stateVersion = "24.05";
    };
    nixos = {
      # sets the nix packages path to match the one from this flake
      # this means when the <nixpkgs> syntax is used it will match the system packages
      nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

      # automatically detects files in the store that have identical contents,
      # and replaces them with hard links to a single copy. This saves disk space.
      nix.settings.auto-optimise-store = true;

      # allow unfree packages by default
      # this allows installing packages that are not FOSS
      # while I prefer FOSS applications, this restriction can be frustrating
      nixpkgs.config.allowUnfree = true;

      # enables expetimental flakes and nix command features on this system by default
      # without this, many flake based commands would need `--extra-experimental-features flakes`
      nix.settings.experimental-features = ["nix-command" "flakes"];

      stateVersion = "24.05";
    };
  };
}
