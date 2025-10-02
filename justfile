default:
    @just --list

# updates the lockfile for this flake
update:
    nix flake update

# builds and enables the current systems flake next boot
boot host=(`hostname`):
    sudo nixos-rebuild --flake .#{{host}} boot

# builds and activates the current systems flake
switch host=(`hostname`):
    sudo nixos-rebuild --flake .#{{host}} switch

# does a dry build of the current systems flake
try host=(`hostname`):
    nixos-rebuild --flake .#{{host}} dry-build
