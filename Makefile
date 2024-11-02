.PHONY: install install-mac install-linux update update-mac update-linux help

help:
	@echo "Available commands:"
	@echo "  make install        - Install Nix and required components (auto-detects OS)"
	@echo "  make install-mac    - Install Nix and Darwin components for MacOS"
	@echo "  make install-linux  - Install Nix for Linux"
	@echo "  make update        - Update system (auto-detects OS)"
	@echo "  make update-mac    - Update MacOS specifically"
	@echo "  make update-linux  - Update Linux specifically"

install:
	@if [[ "$$(uname)" == "Darwin" ]]; then \
		$(MAKE) install-mac; \
	else \
		$(MAKE) install-linux; \
	fi

install-mac:
	@if command -v nix >/dev/null 2>&1; then \
		echo "Nix is already installed"; \
	else \
		echo "Installing Nix..."; \
		sh <(curl -L https://nixos.org/nix/install); \
	fi
	@if command -v darwin-rebuild >/dev/null 2>&1; then \
		echo "Nix-darwin is already installed"; \
	else \
		echo "Installing nix-darwin..."; \
		nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer; \
		./result/bin/darwin-installer; \
	fi
	@if [ -f ~/.config/nix/nix.conf ] && grep -q "experimental-features.*nix-command.*flakes" ~/.config/nix/nix.conf; then \
		echo "Flakes already enabled"; \
	else \
		echo "Enabling flakes..."; \
		mkdir -p ~/.config/nix; \
		echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf; \
	fi

install-linux:
	@if command -v nix >/dev/null 2>&1; then \
		echo "Nix is already installed"; \
	else \
		echo "Installing Nix..."; \
		sh <(curl -L https://nixos.org/nix/install) --daemon; \
	fi
	@if [ -f ~/.config/nix/nix.conf ] && grep -q "experimental-features.*nix-command.*flakes" ~/.config/nix/nix.conf; then \
		echo "Flakes already enabled"; \
	else \
		echo "Enabling flakes..."; \
		mkdir -p ~/.config/nix; \
		echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf; \
	fi

update:
	@if [[ "$$(uname)" == "Darwin" ]]; then \
		$(MAKE) update-mac; \
	else \
		$(MAKE) update-linux; \
	fi

update-mac:
	nix flake update
	darwin-rebuild switch --flake .#mac

update-linux:
	nix flake update
	sudo nixos-rebuild switch --flake .#linux

# Check flake configuration
lint:
	nix run --extra-experimental-features 'nix-command flakes' nixpkgs#statix -- check .

# Clean up old generations and store
clean:
	nix-collect-garbage -d
	home-manager generations
