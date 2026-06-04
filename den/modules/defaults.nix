{
  lib,
  den,
  inputs,
  ...
}: {
  # import flakeModule to generate top level flake structure
  imports = [inputs.den.flakeModule];

  # use home manager as a default class for all users
  den.schema.user.classes = lib.mkDefault ["homeManager"];

  # auto-import _<class> directories under each host and user
  den.schema.host.includes = [(den.batteries.import-tree.provides.host ./hosts)];
  den.schema.user.includes = [(den.batteries.import-tree.provides.user ./users)];

  # apply default settings across all classes
  den.default = {
    includes = [
      # Sets the system hostname as defined in den.hosts.<name>.hostName
      den.batteries.hostname
      # Sets users.users.<name> on NixOS/Darwin and home.username/home.homeDirectory for Home Manager.
      den.batteries.define-user
    ];

    # allow unfree packages globally
    nixos.nixpkgs.config.allowUnfree = true;
    homeManager.nixpkgs.config.allowUnfree = true;

    # initial state versions for this configuration
    # these should not be changed unless you know what you are doing
    nixos.system.stateVersion = "24.05";
    homeManager.home.stateVersion = "24.05";

    # nix daemon settings (nixos only)
    nixos = {
      # sets the system 'nixpkgs' path to match the one used in this flake
      # this means <nixpkgs> syntax will match system packages
      nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
      # replaces identical files in the store with hard links to save disk space
      nix.settings.auto-optimise-store = true;
      # enables flakes and the nix command without --extra-experimental-features
      nix.settings.experimental-features = ["nix-command" "flakes"];
    };
  };
}
