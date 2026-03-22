#!/usr/bin/env bash
set -e

# 1. Packages & Docker Setup
sudo apt update
sudo apt install -y \
    build-essential curl git tmux vim-gtk3 \
    fzf nodejs npm xdg-utils ca-certificates \
    bash-completion tree unzip rsync gh

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl start docker

# 2. Dotfiles & Config
DOT_RAW="https://raw.githubusercontent.com/ganeshkumar0x/x/refs/heads/main/dotfiles"
WSL_RAW="https://raw.githubusercontent.com/ganeshkumar0x/wsl-config/refs/heads/main/scripts"

curl -L "$DOT_RAW/.bashrc" -o ~/.bashrc
curl -L "$DOT_RAW/.vimrc" -o ~/.vimrc
curl -L "$DOT_RAW/.tmux.conf" -o ~/.tmux.conf

WIN_USER=$(/mnt/c/Windows/System32/cmd.exe /c "echo %USERNAME%" | tr -d '\r')
ALACRITTY_DIR="/mnt/c/Users/$WIN_USER/AppData/Roaming/alacritty"
mkdir -p "$ALACRITTY_DIR"

curl -L "$DOT_RAW/alacritty.toml" -o "$ALACRITTY_DIR/alacritty.toml"

cat << 'EOF' >> "$ALACRITTY_DIR/alacritty.toml"

# Terminal
[terminal]
shell = { program = "wsl.exe", args = ["-d", "Debian", "--cd", "~"] }
EOF

# 3. Utility Binaries
sudo curl -L "$WSL_RAW/win-sync" -o /usr/local/bin/win-sync
sudo curl -L "$WSL_RAW/gh-sync" -o /usr/local/bin/gh-sync
sudo chmod +x /usr/local/bin/win-sync /usr/local/bin/gh-sync

# 4. WSL Integration & Clipboard
cat << 'EOF' >> ~/.bashrc

# WSL
export TERM=xterm-256color
EOF

cat << 'EOF' >> ~/.vimrc

" WSL
set t_te=
xnoremap <silent> <Space>y y:call system('win32yank.exe -i --crlf', getreg('"'))<CR>
nnoremap <silent> <Space>y :call system('win32yank.exe -i --crlf', getline('.'))<CR>
nnoremap <silent> <Space>p :execute 'normal! i' . substitute(system('win32yank.exe -o --lf'), '\n$', '', '')<CR>
EOF

curl -LO https://github.com/equalsraf/win32yank/releases/download/v0.1.1/win32yank-x64.zip
unzip -o win32yank-x64.zip
chmod +x win32yank.exe
sudo mv -f win32yank.exe /usr/local/bin/
rm -f win32yank-x64.zip

echo "Setup complete. Run: source ~/.bashrc"
