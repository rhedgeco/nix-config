default_target := `hostname`

switch target=(default_target):
    sudo nixos-rebuild --flake .#{{target}} switch

sync branch="main":
    git checkout --force -t origin/{{branch}}