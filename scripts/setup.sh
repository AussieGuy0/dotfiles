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
        read -rp "Enter your github username: " gh_username
    else
        gh_username=$GH_USERNAME
    fi

    cp .gitconfig.example "$HOME/.gitconfig"
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
