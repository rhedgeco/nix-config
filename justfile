# lists the available `just` commands
default:
    @just --list

# updates the lockfile for this flake
update:
    nix flake update

# builds and enables the `host` flake for next boot
boot host=(`hostname`):
    sudo nixos-rebuild --flake '.?submodules=1#{{host}}' boot

# builds and activates the `host` flake
switch host=(`hostname`):
    sudo nixos-rebuild --flake '.?submodules=1#{{host}}' switch

# does a dry build of the `host` flake
dry host=(`hostname`):
    nixos-rebuild --flake '.?submodules=1#{{host}}' dry-build

yoink user=(`whoami`):
    yoink -r ./users/{{user}}
