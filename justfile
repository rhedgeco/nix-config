system := `hostname`

default:
    @just --list

switch system=(system):
    sudo nixos-rebuild --flake .#{{system}} switch
