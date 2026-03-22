# wsl-config

A collection of scripts to automate the setup and synchronization of a Debian WSL environment.

## Structure
- `setup.sh`: Main installation script for packages, Docker, dotfiles, and utilities.
- `scripts/gh-sync`: Utility to clone or pull all repositories from a GitHub Organization.
- `scripts/win-sync`: Utility to mirror WSL project directories to the Windows host.

## Usage
1. Clone this repository:
   `git clone https://github.com/ganeshkumar0x/wsl-config.git`
2. Navigate to the directory:
   `cd wsl-config`
3. Make the setup script executable:
   `chmod +x setup.sh`
4. Run the setup:
   `./setup.sh`

## Post-Installation
After running the setup, restart your terminal or run:
`source ~/.bashrc`
