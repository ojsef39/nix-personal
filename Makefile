.PHONY: all deploy update lint clean repair install format

all: deploy

# Full system deployment
deploy:
	@if [ "$$(uname)" = "Darwin" ]; then \
		$(MAKE) deploy-darwin; \
	else \
		$(MAKE) deploy-nixos; \
	fi

# Deploy only nix-darwin changes
deploy-darwin:
	darwin-rebuild switch --flake .#mac

deploy-nixos:
	sudo nixos-rebuild switch --flake .#nixos

update-reset:
	@git reset HEAD --hard
	@git pull --rebase
	nix flake update
	$(MAKE) update

# Update nix-darwin and show changelog
update:
	nix-channel --update
	nix --extra-experimental-features nix-command --extra-experimental-features flakes flake update
	$(MAKE) deploy

# Setup homebrew, nix, nix-darwin and home-manager
install:
	@if [ "$$(uname)" != "Darwin" ]; then \
		echo "Install is only supported on MacOS"; \
		exit 1; \
	fi
	# Install Nix
	@if ! command -v nix >/dev/null 2>&1; then \
		curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install; \
		echo ""; \
		echo "==> Nix installed successfully!"; \
		echo "==> Please RESTART YOUR TERMINAL and run 'make install' again to continue the installation process."; \
		echo ""; \
		exit 1; \
	fi
	# Setup Nix channels
	nix-channel --remove darwin || true
	nix-channel --remove home-manager || true
	nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
	nix-channel --add https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin
	nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	nix-channel --update
	# Install home-manager
	nix-shell '<home-manager>' -A install
	# Install nix-darwin
	@if ! command -v darwin-rebuild > /dev/null 2>&1; then \
		echo "Installing nix-darwin..." && \
		nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer && \
		./result/bin/darwin-installer; \
	fi
	# Install Homebrew if not installed
	@command -v brew >/dev/null 2>&1 || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	@echo ""
	@echo "==> YOU CAN IGNORE HOMEBREW INSTRUCTIONS ABOVE"
	@echo ""
	@echo "==> Installation complete!"
	@echo "==> Please restart your shell and run 'make deploy'"
	@echo ""
# Check flake configuration
lint:
	nix run --extra-experimental-features 'nix-command flakes' nixpkgs#statix -- check .

# Dry run deployment
check:
	@if [ "$$(uname)" == "Darwin" ]; then \
		darwin-rebuild switch --check --flake .#mac; \
		nix build .#darwinConfigurations.mac.system --dry-run; \
	fi

# Clean up old generations and store
clean:
	@read -p "Are you sure? [y/N] " ans; \
	if [ "$$ans" = "y" ]; then \
		sudo nix-collect-garbage -d; \
	else \
		echo "Clean cancelled."; \
	fi

repair:
	sudo nix-store --verify --check-contents --repair

format:
	nix --extra-experimental-features nix-command --extra-experimental-features flakes fmt

git-reset:
	git reset HEAD --hard
	git pull --rebase
	clear

uninstall:
	@read -p "Are you sure? [y/N] " ans; \
	if [ "$$ans" != "y" ]; then \
		echo "Aborting."; \
		exit 1; \
	fi; \
	if [ "$$(uname)" != "Darwin" ]; then \
		echo "Uninstall is only supported on MacOS"; \
		exit 1; \
	fi; \
	echo "Restoring original shell configuration files..."; \
	sudo mv /etc/zshrc.backup-before-nix /etc/zshrc 2>/dev/null || true; \
	sudo mv /etc/bashrc.backup-before-nix /etc/bashrc 2>/dev/null || true; \
	sudo mv /etc/bash.bashrc.backup-before-nix /etc/bash.bashrc 2>/dev/null || true; \
	echo "Stopping Nix-related services..."; \
	sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist 2>/dev/null || true; \
	sudo launchctl unload /Library/LaunchDaemons/org.nixos.darwin-store.plist 2>/dev/null || true; \
	echo "Removing LaunchDaemons..."; \
	sudo rm -f /Library/LaunchDaemons/org.nixos.nix-daemon.plist; \
	sudo rm -f /Library/LaunchDaemons/org.nixos.darwin-store.plist; \
	echo "Removing build users and group..."; \
	sudo dscl . -delete /Groups/nixbld 2>/dev/null || true; \
	for u in $$(sudo dscl . -list /Users | grep _nixbld); do \
		sudo dscl . -delete /Users/$$u 2>/dev/null || true; \
	done; \
	echo "Cleaning up fstab entry..."; \
	sudo sed -i '.bak' '/\/nix/d' /etc/fstab || true; \
	echo "Removing synthetic.conf entry..."; \
	if [ -f /etc/synthetic.conf ]; then \
		sudo sed -i '.bak' '/^nix/d' /etc/synthetic.conf; \
		if [ ! -s /etc/synthetic.conf ]; then \
			sudo rm /etc/synthetic.conf; \
		fi; \
	fi; \
	echo "Removing Nix files and directories..."; \
	sudo rm -rf /etc/nix /var/root/.nix-profile /var/root/.nix-defexpr /var/root/.nix-channels; \
	rm -rf ~/.nix-profile ~/.nix-defexpr ~/.nix-channels; \
	echo "Unmounting and removing Nix store volume..."; \
	if mount | grep -q '/nix'; then \
		sudo diskutil unmount force /nix 2>/dev/null || true; \
	fi; \
	NIX_VOLUME=$$(diskutil list | grep "Nix Store" | awk '{print $$NF}'); \
	if [ ! -z "$$NIX_VOLUME" ]; then \
		sudo diskutil apfs deleteVolume $$NIX_VOLUME || true; \
	fi; \
	echo "Removing /nix directory..."; \
	sudo rm -rf /nix; \
	echo "==> Nix uninstallation complete."; \
	echo "==> Note: You may need to restart your shell or terminal."

help:
	@echo "Available commands:"
	@echo "  make install        - Install Nix and required components (auto-detects OS)"
	@echo "  make deploy         - Full system deployment (auto-detects OS)"
	@echo "  make update         - Update nix-darwin and show changelog"
	@echo "  make update-reset   - Update nix-darwin and reset local changes"
	@echo "  make lint           - Check flake configuration"
	@echo "  make clean          - Clean up old generations"
	@echo "  make repair         - Repair nix store"
	@echo "  make format         - Format flake configuration"

