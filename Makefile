MAKEFLAGS += --no-print-directory

NIX_FLAGS = --extra-experimental-features 'nix-command flakes'

# Color output
INFO := \033[1;34m==> \033[0m
SUCCESS := \033[1;32m==> \033[0m
ERROR := \033[1;31m==> ERROR: \033[0m
WARN := \033[1;33m==> WARNING: \033[0m

.PHONY: all deploy update lint clean repair install format check reset uninstall help

all: select

# Command selector
select:
	@if command -v fzf >/dev/null 2>&1; then \
		echo "${INFO}Select a command to run:"; \
		grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
			awk 'BEGIN {FS = ":.*?## "}; {printf "%s - %s\n", $$1, $$2}' | \
			fzf --prompt='Select command: ' | cut -d ' ' -f1 | \
			xargs -I {} make {}; \
	else \
		echo "${WARN}fzf not found, showing help instead"; \
		make help; \
	fi

update: ## Update flakes (and deploy, if you want)
	@echo "${INFO}Updating flakes..."
	@nix $(NIX_FLAGS) flake update
	@echo "${SUCCESS}Updates complete"
	@echo "Would you like to deploy now? Y/n/c(leanup after) - Auto-continues in 30s: "; \
	read -t 30 -p "" response || response="Y"; echo; \
	if [ "$$response" != "Y" ] && [ "$$response" != "y" ] && [ "$$response" != "c" ]; then \
		echo "${INFO}Deployment skipped"; \
		exit 1; \
	fi; \
	$(MAKE) deploy; \
	if [ "$$response" = "c" ]; then \
		$(MAKE) clean; \
	fi

# System deployment
deploy: ## Deploy system configuration
	@echo "${INFO}Running checks..."
	@$(MAKE) -s check || (echo "${ERROR}Checks failed" && exit 1)
	@echo "${INFO}Deploying configuration..."
	@if [ "$$(uname)" = "Darwin" ]; then \
		if darwin-rebuild switch --flake .#mac; then \
			echo "${SUCCESS}Configuration deployed successfully"; \
		else \
			echo "${ERROR}Configuration deployment failed"; \
			exit 1; \
		fi \
	else \
		if sudo nixos-rebuild switch --flake .#nixos; then \
			echo "${SUCCESS}Configuration deployed successfully"; \
		else \
			echo "${ERROR}Configuration deployment failed"; \
			exit 1; \
		fi \
	fi

check: ## Check configuration
	@echo "${INFO}Checking configuration..."
	@nix flake check
	@echo "${INFO}Dry-running configuration... (This can take a while)"
	@DRYRUN_OUTPUT=$$(if [ "$$(uname)" = "Darwin" ]; then \
		nix build .#darwinConfigurations.mac.system --dry-run 2>&1; \
	else \
		nix build .#nixosConfigurations.nixos.system --dry-run 2>&1; \
	fi | grep -v "warning: Git tree" || true); \
	if [ -n "$$DRYRUN_OUTPUT" ]; then \
		echo "$$DRYRUN_OUTPUT"; \
		read -t 30 -n 1 -p "Looks good? (Y/n) - DEFAULT IS 'Y' AFTER 30 SECONDS!: " response; echo; \
		if [ -n "$$response" ] && [ "$$response" != "Y" ] && [ "$$response" != "y" ]; then \
			echo "Deployment cancelled."; \
			exit 1; \
		fi; \
	fi
	@echo "${SUCCESS}Checks passed"

lint: ## Run linters
	@echo "${INFO}Running lints..."
	@nix run $(NIX_FLAGS) nixpkgs#statix -- check .
	@nix run $(NIX_FLAGS) nixpkgs#deadnix -- -eq .
	@echo "${SUCCESS}Linting complete"

clean: ## Clean up old generations
	@echo "${INFO}Cleaning up old generations..."
	@sudo nix-collect-garbage --delete-older-than 2w --keep-going
	@nix-collect-garbage --delete-older-than 2w --keep-going
	@echo "${INFO}Optimizing store.."
	@nix-store --gc
	@nix-store --optimise
	@echo "${SUCCESS}Cleanup complete"

format: ## Format nix files
	@echo "${INFO}Formatting Nix files..."
	@nix $(NIX_FLAGS) fmt .
	@echo "${SUCCESS}Formatting complete"

repair: ## Repair nix store
	@echo "${INFO}Verifying and repairing Nix store..."
	@sudo nix-store --verify --check-contents --repair
	@echo "${SUCCESS}Repair complete"

reset: ## Reset local changes, update flakes and deploy
	@echo "${INFO}Resetting local changes..."
	@git reset HEAD --hard
	@git pull --rebase
	@echo "${INFO}Updating flakes..."
	@nix $(NIX_FLAGS) flake update
	@$(MAKE) deploy

install: ## Install Nix and required components
	@if [ "$$(uname)" != "Darwin" ]; then \
		echo "${ERROR}Install is only supported on MacOS"; \
		exit 1; \
		fi
	@echo "${INFO}Starting MacOS Setup"
	@if ! command -v nix >/dev/null 2>&1; then \
		echo "${INFO}Installing Nix..." && \
		curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install && \
		echo "${SUCCESS}Nix installed successfully!" && \
		echo "${WARN}Please restart your terminal and run 'make install' again." && \
		exit 0; \
		fi
	@echo "${INFO}Installing Homebrew..."
	@command -v brew >/dev/null 2>&1 || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	@if ! command -v darwin-rebuild > /dev/null 2>&1; then \
		echo "${INFO}Building initial configuration..." && \
		nix build .#darwinConfigurations.mac.system $(NIX_FLAGS) && \
		./result/sw/bin/darwin-rebuild switch --flake .#mac; \
		fi
	@echo "${SUCCESS}Installation complete!"
	@echo "${WARN}Please restart your shell and run 'make deploy'\n"

uninstall: ## Uninstall Nix
	@read -p "Are you sure? [y/N] " ans; \
	if [ "$$ans" != "y" ]; then \
		echo "Aborting."; \
		exit 1; \
	fi; \
	darwin-uninstaller
	/nix/nix-installer uninstall
	echo "${SUCCESS}Nix uninstallation complete."; \
	echo "${WARN}Note: You may need to restart your shell or terminal."

help: ## Show this help
	@echo "Available commands:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  make \033[36m%-10s\033[0m %s\n", $$1, $$2}'
