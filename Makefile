.PHONY: install install-mac install-linux update update-mac update-linux help clean lint message_installation_complete

SHELL := /bin/bash
UNAME := $(shell uname)

help:
	@echo "Available commands:"
	@echo "  make install        - Install Nix and required components (auto-detects OS)"
	@echo "  make install-mac    - Install Nix and Darwin components for MacOS"
	@echo "  make install-linux  - Install Nix for Linux"
	@echo "  make update-full    - Update system (auto-detects OS, RESETS LOCAL REPO)"
	@echo "  make update         - Update system (auto-detects OS, only updates base)"
	@echo "  make update-mac     - Update MacOS specifically"
	@echo "  make update-linux   - Update Linux specifically"
	@echo "  make lint           - Check flake configuration"
	@echo "  make clean          - Clean up old generations"

install:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		$(MAKE) install-mac; \
	else \
		$(MAKE) install-linux; \
	fi

install-mac:
	@if command -v nix > /dev/null 2>&1; then \
		echo "Nix is already installed"; \
	else \
		echo "Installing Nix..." && \
		curl -L https://nixos.org/nix/install | sh; \
		echo ""; \
		echo "==> Part 1/2 complete!"; \
		echo "==> Please restart your shell and run 'make install' again!"; \
		echo ""; \
		exit 0; \
	fi
	# Install Homebrew if not installed
	@command -v brew >/dev/null 2>&1 || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	# Setup channels
	nix-channel --remove darwin || true
	nix-channel --remove home-manager || true
	nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
	nix-channel --add https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin
	nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	nix-channel --update
	# Install home-manager
	nix-shell '<home-manager>' -A install
	@if command -v darwin-rebuild > /dev/null 2>&1; then \
		echo "Nix-darwin is already installed"; \
	else \
		echo "Installing nix-darwin..." && \
		nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer && \
		./result/bin/darwin-installer; \
	fi
	@if [ -f ~/.config/nix/nix.conf ] && grep -q "experimental-features.*nix-command.*flakes" ~/.config/nix/nix.conf; then \
		echo "Flakes already enabled"; \
	else \
		echo "Enabling flakes..." && \
		mkdir -p ~/.config/nix && \
		echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf; \
	fi
	$(MAKE) message_installation_complete

install-linux:
	@if command -v nix > /dev/null 2>&1; then \
		echo "Nix is already installed"; \
	else \
		echo "Installing Nix..." && \
		curl -L https://nixos.org/nix/install | sh -s -- --daemon; \
	fi
	@if [ -f ~/.config/nix/nix.conf ] && grep -q "experimental-features.*nix-command.*flakes" ~/.config/nix/nix.conf; then \
		echo "Flakes already enabled"; \
	else \
		echo "Enabling flakes..." && \
		mkdir -p ~/.config/nix && \
		echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf; \
	fi
	$(MAKE) message_installation_complete

update-full:
	@git reset HEAD --hard
	@git pull --rebase
	nix flake update
	$(MAKE) update_

update:
	nix flake lock --update-input base
	$(MAKE) update_

update_:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		$(MAKE) update-mac; \
	else \
		$(MAKE) update-linux; \
	fi

update-mac:
	darwin-rebuild switch --flake .#mac

update-linux:
	sudo nixos-rebuild switch --flake .#linux

lint:
	nix run --extra-experimental-features 'nix-command flakes' nixpkgs#statix -- check .

clean:
	nix-collect-garbage -d
	@if command -v home-manager > /dev/null 2>&1; then \
		home-manager generations; \
	fi

message_installation_complete:
	@echo ""
	@echo "==> Installation complete!"
	@echo "==> Please restart your shell and run 'make update' to install config"
	@echo ""
