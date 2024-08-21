default_target := `hostname`

switch target=(default_target):
    sudo nixos-rebuild --flake .#{{target}} switch