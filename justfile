default_target := `hostname`

switch target=(default_target):
    sudo nixos-rebuild --flake .#{{target}} switch

upgrade target=(default_target):
    nix flake update
    sudo nixos-rebuild --flake .#{{target}} switch --upgrade

init:
    git init --initial-branch=main
    git remote add origin git@github.com:rhedgeco/nix-config.git
    git fetch origin
    git checkout --force -t origin/main
