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

# Returns the browser_download_url for the latest GitHub release asset matching pattern
gh_latest_url() {
    local repo="$1" pattern="$2"
    curl -fsSL "https://api.github.com/repos/$repo/releases/latest" \
        | python3 -c "
import sys, json
assets = json.load(sys.stdin).get('assets', [])
matches = [a['browser_download_url'] for a in assets if sys.argv[1] in a['name']]
print(matches[0] if matches else '', end='')
" "$pattern"
}

# Downloads a .deb from a URL and installs it
install_deb() {
    local url="$1"
    local tmp; tmp=$(mktemp --suffix=.deb)
    wget -q --show-progress -O "$tmp" "$url"
    sudo apt-get install -y "$tmp"
    rm -f "$tmp"
}

# Downloads a zip from a URL, finds a named binary inside, and puts it in dest
install_zip_binary() {
    local url="$1" binary="$2" dest="${3:-$HOME/.local/bin}"
    local tmp_dir; tmp_dir=$(mktemp -d)
    wget -q --show-progress -O "$tmp_dir/download.zip" "$url"
    unzip -q "$tmp_dir/download.zip" -d "$tmp_dir"
    mkdir -p "$dest"
    find "$tmp_dir" -type f -name "$binary" | head -1 | xargs -I{} cp {} "$dest/$binary"
    chmod +x "$dest/$binary"
    rm -rf "$tmp_dir"
}

if [ "$machine" = "Linux" ]; then
    echo "==> Updating apt and installing packages"
    sudo apt-get update
    sudo apt-get install -y \
        git curl wget gpg python3 unzip \
        openssh-client xclip xdg-utils \
        cmake gcc libclang-dev sqlite3 zstd \
        clojure \
        fd-find fzf \
        neovim \
        i3 j4-dmenu-desktop \
        vlc firefox chromium-browser flameshot copyq bubblewrap

    # fd is packaged as 'fdfind' on Ubuntu; symlink to 'fd'
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

    echo "==> Installing OBS Studio"
    sudo add-apt-repository -y ppa:obsproject/obs-studio
    sudo apt-get update && sudo apt-get install -y obs-studio

    echo "==> Installing Spotify"
    curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg \
        | sudo gpg --dearmor --output /usr/share/keyrings/spotify.gpg
    echo "deb [signed-by=/usr/share/keyrings/spotify.gpg] http://repository.spotify.com stable non-free" \
        | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update && sudo apt-get install -y spotify-client

    echo "==> Installing Discord"
    wget -O /tmp/discord.deb 'https://discord.com/api/download?platform=linux&format=deb'
    sudo apt-get install -y /tmp/discord.deb
    rm -f /tmp/discord.deb

    echo "==> Installing Obsidian"
    OBSIDIAN_URL=$(gh_latest_url "obsidianmd/obsidian-releases" "_amd64.deb")
    [ -n "$OBSIDIAN_URL" ] && install_deb "$OBSIDIAN_URL" \
        || echo "  WARNING: Obsidian release not found. Install manually: https://obsidian.md/download"

    echo "==> Installing Anki"
    ANKI_URL=$(gh_latest_url "ankitects/anki" "linux-qt6.tar.zst")
    if [ -n "$ANKI_URL" ]; then
        ANKI_TMP=$(mktemp -d)
        wget -q --show-progress -O "$ANKI_TMP/anki.tar.zst" "$ANKI_URL"
        tar -C "$ANKI_TMP" -xf "$ANKI_TMP/anki.tar.zst"
        (cd "$ANKI_TMP"/anki-*/ && sudo ./install.sh)
        rm -rf "$ANKI_TMP"
    else
        echo "  WARNING: Anki release not found. Install manually: https://apps.ankiweb.net/"
    fi

    echo "==> Installing JetBrains Toolbox"
    TOOLBOX_TMP=$(mktemp -d)
    wget -q --show-progress -O "$TOOLBOX_TMP/toolbox.tar.gz" \
        'https://data.services.jetbrains.com/products/download?platform=linux&code=TBA'
    tar -C "$TOOLBOX_TMP" -xzf "$TOOLBOX_TMP/toolbox.tar.gz"
    mkdir -p "$HOME/.local/bin"
    find "$TOOLBOX_TMP" -name 'jetbrains-toolbox' -type f \
        | head -1 | xargs -I{} cp {} "$HOME/.local/bin/jetbrains-toolbox"
    chmod +x "$HOME/.local/bin/jetbrains-toolbox"
    rm -rf "$TOOLBOX_TMP"
    "$HOME/.local/bin/jetbrains-toolbox" &

    echo "==> Installing Ghostty"
    GHOSTTY_URL=$(gh_latest_url "mkasberg/ghostty-ubuntu" "_amd64.deb")
    [ -n "$GHOSTTY_URL" ] && install_deb "$GHOSTTY_URL" \
        || echo "  WARNING: Ghostty deb not found. Install manually: https://ghostty.org/download"

    echo "==> Installing clojure-lsp"
    CLOJURE_LSP_URL=$(gh_latest_url "clojure-lsp/clojure-lsp" "native-linux-amd64.zip")
    [ -n "$CLOJURE_LSP_URL" ] && install_zip_binary "$CLOJURE_LSP_URL" "clojure-lsp" \
        || echo "  WARNING: clojure-lsp release not found."

    echo "==> Installing clj-kondo"
    CLJKONDO_URL=$(gh_latest_url "clj-kondo/clj-kondo" "linux-amd64.zip")
    [ -n "$CLJKONDO_URL" ] && install_zip_binary "$CLJKONDO_URL" "clj-kondo" \
        || echo "  WARNING: clj-kondo release not found."

    echo ""
    echo "==> One remaining manual install:"
    echo "    Cursor: https://cursor.sh/"
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
