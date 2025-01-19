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

# Update system and install packages on Linux (assuming Debian based system)
if [ "$machine" = "Linux" ]
then
    # Setting up nix.
    echo "Installing nix"
    sh <(curl -L https://nixos.org/nix/install) --daemon
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    echo "First run of home manager, this may take a while!"
    nix-update

    # https://regolith-desktop.com/docs/using-regolith/install/
    echo "Installing regolith"
    wget -qO - https://regolith-desktop.org/regolith.key | \
gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null
    echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://regolith-desktop.org/release-3_2-ubuntu-noble-amd64 noble main" | \
sudo tee /etc/apt/sources.list.d/regolith.list
    sudo apt update
    sudo apt install regolith-desktop regolith-session-flashback regolith-look-lascaille
    echo "Regolith installled - relogin to see it"

fi

# Setup vim
echo "Setting up vim"

# https://github.com/junegunn/vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
vim +PlugInstall

# Setup .gitconfig
if [ ! -f "$HOME/.gitconfig" ]; then
    echo "Setting up .gitconfig"
    if [ -z "$EMAIL" ]; then
        read -rp "Enter your email: " email
    else
        email=$EMAIL
    fi
    if [ -z "$GH_USERNAME" ]; then
        read -rp "Enter your github username: " email
    else
        gh_username=$GH_USERNAME
    fi

    cp .gitconfig.template "$HOME/.gitconfig"
    {
        echo "\n[user]" -e
        echo "\temail = $email" -e
        echo "\tname= $gh_username" -e
    }  >> "$HOME/.gitconfig"
fi

# Setup ssh key
echo "Would you like to generate a SSH key? (Y/N)"
read -r answer
if [ "$answer" = "Y" ]
then
    ssh-keygen -t ed25519
fi
