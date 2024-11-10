# nix-personal

# nix-base

[![Build Status](https://github.com/ojsef39/nix-personal/actions/workflows/validate.yml/badge.svg)](https://github.com/ojsef39/nix-personal/actions/workflows/validate.yml)
![GitHub repo size](https://img.shields.io/github/repo-size/ojsef39/nix-personal)
![GitHub License](https://img.shields.io/github/license/ojsef39/nix-personal)

This repository contains my Nix configuration for both macOS and Linux systems.

It is designed to merge (the config as input) with [ojsef39/nix-base](https://github.com/ojsef39/nix-base) configuration to create a complete system configuration.

## TODOs

## Key Files and Their Purpose

### Top-Level Files

- `flake.nix`: Entry point for the Nix flake configuration, defining inputs and outputs.
- `Makefile`: Automation scripts for building and deploying configurations.
- `renovate.json`: Configuration for dependency updates.

### Shared Configuration

- `nix/core.nix`: Core Nix configurations shared across all systems.

- `hosts/shared/`: Shared configurations and programs used by both macOS and Linux.
  - `import.nix`: Imports shared program modules.
  - `programs/`: Contains configurations for various programs:
    - `editor/`
    - `git/`
    - `kitty/`
    - `shell/`
    - `ssh/`
    - `yuki/`
    - `…`

### macOS Configuration (`nix-darwin`)

- `hosts/darwin/`:
  - `import.nix`: Imports macOS-specific modules.
  - `system.nix`: System-level settings and preferences for macOS.
  - `homebrew.nix`: Homebrew package configurations (gets imported seperately).
  - `apps.nix`: Additional applications to install on macOS.

## Installation

### Steps

1. **(darwin) Install Xcode Command Line Tools**

```bash
xcode-select --install
```

2. **Clone the Repository**

```bash
git clone https://github.com/ojsef39/nix-personal.git
cd nix-base
```

3. **Install Nix**

Follow steps in (you have to restart your shell a couple of times):
`make install`

4. **Deploy Configuration**

`make deploy`

## Available Commands

```bash
# Full system deployment (auto-detects OS)
make deploy

# Deploy only for macOS
make deploy-darwin

# Deploy only for NixOS
sudo make deploy-nixos

# Update packages and configurations
make update

# Run linters
make lint

# Format the Nix code
make format

# Clean up old generations and store
sudo make clean

# Repair Nix store
sudo make repair

# Uninstall Nix (Caution: This will remove Nix from your system)
make uninstall
```
