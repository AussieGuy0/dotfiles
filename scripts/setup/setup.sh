#!/usr/bin/env bash
set -eu

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$CURR_DIR"

DEVPATH="$HOME/dev"
TOOLDIR="$DEVPATH/tools"
IDEDIR="$DEVPATH/ide" 
TOOLBOX="jetbrains-toolbox-1.17.6856.tar.gz"

NVM_VERSION="0.35.3"

echo "Updating system"
sudo apt update
sudo apt -y upgrade 

echo "Installing packages"
cat packages.txt | xargs sudo apt -y install

sudo snap install spotify
sudo snap install code --classic
sudo snap install docker

# Setup dotfiles
echo "Setting up dotfiles"
git clone https://github.com/AussieGuy0/dotfiles.git "$DEVPATH"/dotfiles
cd "$DEVPATH"/dotfiles/scripts
./install-dotfiles.sh
cd "$CURR_DIR"

# Setup vim
echo "Setting up vim"
vim +PluginInstall +qall
cd ~/.vim/bundle/YouCompleteMe
python3 install.py --ts-completer
cd "$CURR_DIR"

# Setup nvm
cd "$TOOLDIR"
git clone https://github.com/nvm-sh/nvm.git nvm
cd nvm
git checkout v"$NVM_VERSION"
cd "$CURR_DIR"


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
