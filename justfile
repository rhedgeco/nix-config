host := `hostname -s`

# lists the available `just` commands
default:
    @just help

# lists the available `just` commands
help:
    @just --list

# updates the lockfile for this flake
update:
    nix flake update --flake .
    @echo -e "\033[1;32mUPDATE COMPLETE\033[0m"

# checks every item in the flake for errors
check:
    nix flake check '.?submodules=1'
    @echo -e "\033[1;32mALL CHECKS PASSED\033[0m"

# opens a nix repl shell with the current flake loaded
inspect:
    nix repl .

# builds the `host` configuration and launches it in a vm
vm host=host *args:
    @nixos-rebuild --flake '.#{{ host }}' build-vm {{ args }}
    ./result/bin/run-*-vm

# does a dry build of the `host` configuration (defaults to the current host)
dry-build host=host *args:
    nixos-rebuild --flake '.#{{ host }}' dry-build {{ args }}

# builds and activates the `host` configuration (defaults to the current host)
switch host=host:
    sudo nixos-rebuild --flake '.?submodules=1#{{ host }}' switch

# builds and enables the `host` configuration for next boot (defaults to the current host)
boot host=host:
    sudo nixos-rebuild --flake '.?submodules=1#{{ host }}' boot
    @gum confirm "Reboot Now?" --default="No"
    @reboot

# collects all leftover nix garbage older than `period` (defaults to 30d)
clean period="30d":
    @gum confirm "Are you sure you want to delete nix content older than {{ period }}?" --default="No"
    nix-collect-garbage --delete-older-than {{ period }}

# deletes and removes everything not related to the current running system
purge:
    @gum confirm "Are you sure you want to delete *all* old nix content?" --default="No"
    nix-collect-garbage -d
