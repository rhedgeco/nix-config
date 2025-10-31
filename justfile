# lists the available `just` commands
default:
    @just --list

# updates the lockfile for this flake
update:
    nix flake update

# builds and enables the `host` configuration for next boot (defaults to the current host)
boot host=(`hostname`):
    sudo nixos-rebuild --flake '.?submodules=1#{{host}}' boot

# builds and activates the `host` configuration (defaults to the current host)
switch host=(`hostname`):
    sudo nixos-rebuild --flake '.?submodules=1#{{host}}' switch

# does a dry build of the `host` configuration (defaults to the current host)
dry host=(`hostname`):
    nixos-rebuild --flake '.?submodules=1#{{host}}' dry-build

# collects all leftover nix garbage older than `period` (defaults to 30d)
clean period="30d":
    nix-collect-garbage --delete-older-than {{period}}

# yoinks all files related to `user` (defaults to the current user)
yoink user=(`whoami`):
    yoink -r ./users/{{user}}
