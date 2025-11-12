# lists the available `just` commands
default:
    @just --list

# updates the lockfile for this flake
update:
    @nix flake update --flake '.?submodules=1'
    @echo -e "\033[1;32mFLAKE UPDATED\033[0m"

check:
    @nix flake check '.?submodules=1'
    @echo -e "\033[1;32mALL CHECKS PASSED\033[0m"

inspect:
    @nix repl '.?sumodules=1'

# builds and enables the `host` configuration for next boot (defaults to the current host)
boot host=(`hostname`):
    @sudo nixos-rebuild --flake '.?submodules=1#{{host}}' boot
    @gum confirm "Reboot Now?" --default="No"
    @reboot

# builds and activates the `host` configuration (defaults to the current host)
switch host=(`hostname`):
    @sudo nixos-rebuild --flake '.?submodules=1#{{host}}' switch

# does a dry build of the `host` configuration (defaults to the current host)
dry-build host=(`hostname`):
    @nixos-rebuild --flake '.?submodules=1#{{host}}' dry-build

# collects all leftover nix garbage older than `period` (defaults to 30d)
clean period="30d":
    @gum confirm "Are you sure you want to delete nix content older than {{period}}?" --default="No"
    @nix-collect-garbage --delete-older-than {{period}}

# deletes and removes everything not related to the current running system
purge:
    @gum confirm "Are you sure you want to delete *all* old nix content?" --default="No"
    @nix-collect-garbage -d

# yoinks all files related to `user` (defaults to the current user)
yoink user=(`whoami`):
    @yoink -r ./users/{{user}}
