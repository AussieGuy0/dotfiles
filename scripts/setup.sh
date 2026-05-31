#!/usr/bin/env bash
set -eu

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$CURR_DIR"

case "$(uname -s)" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN"
esac

if [ "$machine" = "Linux" ]; then
    echo "==> Installing apt packages"
    sudo apt update
    sudo apt install -y \
        curl git openssh-client xclip bubblewrap \
        cmake gcc libclang-dev sqlite3 \
        fd-find \
        fzf \
        i3 j4-dmenu-desktop \
        firefox vlc flameshot copyq \
        clojure

    echo "==> Installing mise"
    curl https://mise.run | sh
    eval "$(~/.local/bin/mise activate bash)"

    echo "==> Installing language runtimes via mise"
    mise install

    echo "==> Installing Rust-based CLI tools via cargo"
    cargo install eza zellij

    echo "==> Installing flyctl"
    curl -L https://fly.io/install.sh | sh

    echo "==> Installing ghostty"
    # Install ghostty from their Ubuntu package
    # See https://ghostty.org/docs/install/binary
    sudo apt install -y ghostty || echo "ghostty not in apt - install manually from https://ghostty.org/docs/install/binary"

    echo "==> Installing 1Password"
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
    sudo apt update && sudo apt install -y 1password 1password-cli

    echo "==> Installing VS Code"
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
    sudo apt update && sudo apt install -y code

    echo "==> Installing npm globals"
    npm install -g yarn
    npm install -g @anthropic-ai/claude-code

    echo "==> Installing uv tools"
    uv tool install llm

    echo "==> Installing clojure-lsp"
    CLOJURE_LSP_VERSION=$(curl -s https://api.github.com/repos/clojure-lsp/clojure-lsp/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
    curl -sL "https://github.com/clojure-lsp/clojure-lsp/releases/download/${CLOJURE_LSP_VERSION}/clojure-lsp-native-linux-amd64.zip" -o /tmp/clojure-lsp.zip
    unzip -o /tmp/clojure-lsp.zip -d /tmp && sudo mv /tmp/clojure-lsp /usr/local/bin/clojure-lsp

    echo "==> Installing clj-kondo"
    CLJ_KONDO_VERSION=$(curl -s https://api.github.com/repos/clj-kondo/clj-kondo/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
    curl -sL "https://github.com/clj-kondo/clj-kondo/releases/download/${CLJ_KONDO_VERSION}/clj-kondo-${CLJ_KONDO_VERSION#v}-linux-amd64.zip" -o /tmp/clj-kondo.zip
    unzip -o /tmp/clj-kondo.zip -d /tmp && sudo mv /tmp/clj-kondo /usr/local/bin/clj-kondo

    echo ""
    echo "==> The following apps should be installed manually:"
    echo "    - Discord:          https://discord.com/download"
    echo "    - Spotify:          sudo snap install spotify"
    echo "    - Obsidian:         https://obsidian.md/download"
    echo "    - Anki:             https://apps.ankiweb.net"
    echo "    - OBS Studio:       sudo flatpak install flathub com.obsproject.Studio"
    echo "    - JetBrains Toolbox: https://www.jetbrains.com/toolbox-app"
    echo "    - Cursor:           https://www.cursor.com/downloads"
    echo "    - Emote:            sudo snap install emote"
fi

# Setup vim
echo "==> Setting up vim"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
vim +PlugInstall

# Setup .gitconfig
if [ ! -f "$HOME/.gitconfig" ]; then
    echo "==> Setting up .gitconfig"
    if [ -z "${EMAIL:-}" ]; then
        read -rp "Enter your email: " email
    else
        email=$EMAIL
    fi
    if [ -z "${GH_USERNAME:-}" ]; then
        read -rp "Enter your github username: " gh_username
    else
        gh_username=$GH_USERNAME
    fi

    cp .gitconfig.example "$HOME/.gitconfig"
    {
        printf '\n[user]\n'
        printf '\temail = %s\n' "$email"
        printf '\tname = %s\n' "$gh_username"
    } >> "$HOME/.gitconfig"
fi

# Setup ssh key
echo "Would you like to generate a SSH key? (Y/N)"
read -r answer
if [ "$answer" = "Y" ]; then
    ssh-keygen -t ed25519
fi
