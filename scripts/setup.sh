#!/usr/bin/env bash
set -eu

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$CURR_DIR"

DEVPATH="$HOME/dev"
IDEDIR="$DEVPATH/ide"

TOOLBOX="jetbrains-toolbox-1.27.3.14493.tar.gz"
INSYNC="insync_3.8.4.50481-jammy_amd64.deb"

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
    # Alacritty
    sudo add-apt-repository ppa:aslatter/ppa

    # Docker (https://docs.docker.com/engine/install/ubuntu/#set-up-the-repository)
    sudo apt install ca-certificates curl gnupg lsb-release
    sudo mkdir -m 0755 -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo "Updating system"
    sudo apt update
    sudo apt -y upgrade

    echo "Installing packages"
    cat packages.txt | xargs sudo apt -y install

    sudo snap install spotify
    sudo snap install code --classic
    sudo snap install docker

    # Setup SDKMAN
    curl -s "https://get.sdkman.io" | bash
fi

# Setup vim
echo "Setting up vim"

# https://github.com/junegunn/vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
vim +PlugInstall

# Setup ssh key
echo "Would you like to generate a SSH key? (Y/N)"
read -r ANSWER
if [ "$ANSWER" = "Y" ]
then
    ssh-keygen -t ed25519
fi

# Download and install insync
echo "Would you like to install insync? (Y/N)"
read -r ANSWER
if [ "$ANSWER" = "Y" ]
then
    wget -P /tmp "https://cdn.insynchq.com/builds/linux/$INSYNC"
    sudo dpkg -i "/tmp/$INSYNC"
fi

# Download and run Jetbrains Toolbox
echo "Would you like to Jetbrains Toolbox?? (Y/N)"
read -r ANSWER
if [ "$ANSWER" = "Y" ]
then
    echo "Setting up Jetbrains Toolbox"
    wget -P /tmp https://download.jetbrains.com/toolbox/$TOOLBOX
    tar -xvzf /tmp/"$TOOLBOX" -C "$IDEDIR/"
    sh "$IDEDIR/$TOOLBOX"/jetbrans-toolbox
fi
