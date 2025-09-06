system := `hostname`

default:
    @just --list

update:
    nix flake update

switch system=(system):
    sudo nixos-rebuild --flake .#{{system}} switch
