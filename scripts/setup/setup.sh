#!/bin/bash
set -e
DEVPATH="$HOME/dev"
IDEDIR="$DEVPATH/ide" 

TOOLBOX="jetbrains-toolbox-1.16.6319.tar.gz"
NODE_VERSION=12

echo "Updating system"
sudo apt update
sudo apt -y upgrade 

echo "Installing packages"
cat packages.txt | xargs sudo apt -y install

sudo snap install node --classic --channel=$NODE_VERSION
sudo snap install spotify
sudo snap install code
sudo snap install docker

# Setup dotfiles
echo "Setting up dotfiles"
CURR_DIR=$(pwd)
git clone https://github.com/AussieGuy0/dotfiles.git "$DEVPATH"/dotfiles
cd "$DEVPATH"/dotfiles/scripts
./install-dotfiles.sh
cd "$CURR_DIR"

# Setup vim
echo "Setting up vim"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall


# Setup ssh key
echo "Would you like to generate a SSH key? (Y/N)"
read -r ANSWER
if [ "$ANSWER" = "Y" ]
then
    ssh-keygen -t rsa -b 4096
fi

# Download and install insync
echo "Would you like to install insync? (Y/N)"
read -r ANSWER
if [ "$ANSWER" = "Y" ]
then
    wget -P /tmp https://d2t3ff60b2tol4.cloudfront.net/builds/insync_3.0.30.40732-bionic_amd64.deb
    sudo dpkg -i /tmp/insync_3.0.30.40732-bionic_amd64.deb
fi

# Download and run Jetbrains Toolbox
echo "Setting up Jetbrains Toolbox"
wget -P /tmp https://download.jetbrains.com/toolbox/$TOOLBOX
tar -xvzf /tmp/"$TOOLBOX" -C "$IDEDIR/"
sh "$IDEDIR/$TOOLBOX"/jetbrans-toolbox
