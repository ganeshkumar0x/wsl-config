#!/usr/bin/env bash
# setup.sh

set -euo pipefail

sudo apt update

sudo apt install -y \
    bash-completion \
    build-essential \
    ca-certificates \
    curl \
    fzf \
    gh \
    git \
    nodejs \
    npm \
    rsync \
    tmux \
    tree \
    unzip \
    vim-gtk3 \
    xdg-utils

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt update

sudo apt install -y \
    containerd.io \
    docker-buildx-plugin \
    docker-ce \
    docker-ce-cli \
    docker-compose-plugin

sudo usermod -aG docker "$USER"
sudo systemctl enable --now docker

DOT_RAW="https://raw.githubusercontent.com/ganeshkumar0x/x/refs/heads/main/dotfiles"
WSL_RAW="https://raw.githubusercontent.com/ganeshkumar0x/wsl-config/refs/heads/main/scripts"

curl -fsSL "$DOT_RAW/.bashrc" -o "$HOME/.bashrc"
curl -fsSL "$DOT_RAW/.vimrc" -o "$HOME/.vimrc"
curl -fsSL "$DOT_RAW/.tmux.conf" -o "$HOME/.tmux.conf"

WIN_USER="$(/mnt/c/Windows/System32/cmd.exe /c 'echo %USERNAME%' 2>/dev/null | tr -d '\r')"
ALACRITTY_DIR="/mnt/c/Users/$WIN_USER/AppData/Roaming/alacritty"
mkdir -p "$ALACRITTY_DIR"

curl -fsSL "$DOT_RAW/alacritty.toml" -o "$ALACRITTY_DIR/alacritty.toml"

cat >> "$ALACRITTY_DIR/alacritty.toml" <<'EOF'

[terminal]
shell = { program = "wsl.exe", args = ["-d", "Debian", "--cd", "~"] }

[keyboard]
bindings = [
    { key = "Key6", mods = "Control", chars = "\u001e" }
]
EOF

sudo curl -fsSL "$WSL_RAW/win-sync" -o /usr/local/bin/win-sync
sudo curl -fsSL "$WSL_RAW/gh-sync" -o /usr/local/bin/gh-sync
sudo chmod +x /usr/local/bin/win-sync /usr/local/bin/gh-sync

echo "Done. Restart the shell."
