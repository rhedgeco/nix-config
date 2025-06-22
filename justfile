default_target := `hostname`

switch target=(default_target):
    sudo nixos-rebuild --flake .#{{target}} switch

upgrade target=(default_target):
    nix flake update
    sudo nixos-rebuild --flake .#{{target}} switch --upgrade
