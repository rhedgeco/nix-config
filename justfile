default_target := `hostname`

switch target=(default_target):
    sudo nixos-rebuild --flake ./nixos#{{target}} switch