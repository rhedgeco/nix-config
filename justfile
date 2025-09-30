default:
    @just --list

# updates the lockfile for this flake
update:
    nix flake update

# builds and enables the current systems flake next boot
boot:
    sudo nixos-rebuild --flake .#{{`hostname`}} boot

# builds and activates the current systems flake
switch:
    sudo nixos-rebuild --flake .#{{`hostname`}} switch

# does a dry build of the current systems flake
try:
    nixos-rebuild --flake .#{{`hostname`}} dry-build
