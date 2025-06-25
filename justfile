system := `hostname`

default:
    @just --list

switch specialisation="" system=(system):
    @if [ -n '{{specialisation}}' ]; then \
        echo "Rebuilding '{{system}}' with specialization: {{specialisation}}"; \
        sudo nixos-rebuild --flake .#{{system}} switch --specialisation '{{specialisation}}'; \
    else \
        echo "Rebuilding '{{system}}' with base specialization"; \
        sudo nixos-rebuild --flake .#{{system}} switch; \
    fi
