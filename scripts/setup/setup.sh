#!/bin/bash
set -e
DEVPATH="$HOME/dev"
IDEDIR="$DEVPATH/ide" 

TOOLBOX="jetbrains-toolbox-1.14.5179.tar.gz"
NODE_VERSION=12

sudo apt update
sudo apt -y upgrade 

cat packages.txt | xargs sudo apt -y install

sudo snap install node --classic --channel=$NODE_VERSION
sudo snap install spotify
sudo snap install code

# Setup dotfiles
git clone https://github.com/AussieGuy0/dotfiles.git "$DEVPATH"/dotfiles
sh "$DEVPATH"/dotfiles/scripts/install-dotfiles.sh

# Setup vim
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
wget -P /tmp http://s.insynchq.com/builds/insync_1.5.7.37371-artful_amd64.deb
sudo dpkg -i /tmp/insync_1.5.7.37371-artful_amd64.deb

# Download and run Jetbrains Toolbox
wget -P /tmp https://download.jetbrains.com/toolbox/$TOOLBOX
tar -xvzf /tmp/"$TOOLBOX" -C "$IDEDIR/"
sh "$IDEDIR/$TOOLBOX"/jetbrans-toolbox
