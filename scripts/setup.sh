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
    echo "==> Updating apt and installing packages"
    sudo apt-get update
    sudo apt-get install -y \
        git curl wget gpg \
        openssh-client xclip xdg-utils \
        cmake gcc libclang-dev sqlite3 \
        clojure \
        fd-find fzf \
        neovim \
        i3 j4-dmenu-desktop \
        vlc firefox chromium-browser flameshot copyq bubblewrap

    # fd is packaged as 'fdfind' on Ubuntu; add a 'fd' symlink
    if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
        mkdir -p "$HOME/.local/bin"
        ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    fi

    echo "==> Installing mise"
    curl https://mise.run | sh
    export PATH="$HOME/.local/bin:$PATH"

    echo "==> Installing dev tools via mise"
    mise install

    echo "==> Installing npm globals"
    mise exec -- npm install -g yarn
    mise exec -- npm install -g @anthropic-ai/claude-code

    echo "==> Installing 1Password"
    curl -sS https://downloads.1password.com/linux/keys/1password.asc \
        | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' \
        | sudo tee /etc/apt/sources.list.d/1password.list
    sudo apt-get update && sudo apt-get install -y 1password 1password-cli

    echo "==> Installing VS Code"
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
        | gpg --dearmor > /tmp/packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg \
        /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
        | sudo tee /etc/apt/sources.list.d/vscode.list
    sudo apt-get update && sudo apt-get install -y code

    echo ""
    echo "==> The following require manual installation:"
    echo "    Ghostty:        https://ghostty.org/download"
    echo "    Cursor:         https://cursor.sh/"
    echo "    Discord:        https://discord.com/download"
    echo "    Spotify:        https://www.spotify.com/download/linux/"
    echo "    Anki:           https://apps.ankiweb.net/"
    echo "    Obsidian:       https://obsidian.md/download"
    echo "    JetBrains:      https://www.jetbrains.com/toolbox-app/"
    echo "    OBS Studio:     sudo add-apt-repository ppa:obsproject/obs-studio && sudo apt install obs-studio"
    echo "    clojure-lsp:    https://github.com/clojure-lsp/clojure-lsp/releases"
    echo "    clj-kondo:      https://github.com/clj-kondo/clj-kondo/releases"
fi

echo ""
echo "==> Setting up vim plugins"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall +qall 2>/dev/null || vim +PlugInstall +qall

# Setup .gitconfig
if [ ! -f "$HOME/.gitconfig" ]; then
    echo ""
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
    printf '\n[user]\n\temail = %s\n\tname = %s\n' "$email" "$gh_username" >> "$HOME/.gitconfig"
fi

echo ""
read -rp "Generate an SSH key? (Y/N) " answer
if [ "$answer" = "Y" ]; then
    ssh-keygen -t ed25519
fi
