host := `hostname -s`

help:
    @just --list

default:
    @just help

update:
    nix flake update --flake .
    @echo -e "\033[1;32mUPDATE COMPLETE\033[0m"

check:
    nix flake check '.?submodules=1'
    @echo -e "\033[1;32mALL CHECKS PASSED\033[0m"

inspect:
    nix repl .

vm host=host *args:
    @nixos-rebuild --flake '.#{{ host }}' build-vm {{ args }}
    ./result/bin/run-*-vm

dry-build host=host *args:
    nixos-rebuild --flake '.#{{ host }}' dry-build {{ args }}

# collects all leftover nix garbage older than `period` (defaults to 30d)
clean period="30d":
    @gum confirm "Are you sure you want to delete nix content older than {{ period }}?" --default="No"
    nix-collect-garbage --delete-older-than {{ period }}

# deletes and removes everything not related to the current running system
purge:
    @gum confirm "Are you sure you want to delete *all* old nix content?" --default="No"
    nix-collect-garbage -d
