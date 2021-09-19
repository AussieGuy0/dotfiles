#!/usr/bin/env bash
set -eu

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$CURR_DIR"

DEVPATH="$HOME/dev"
IDEDIR="$DEVPATH/ide" 

TOOLBOX="jetbrains-toolbox-1.19.7784.tar.gz"
INSYNC="insync_3.5.3.50123-focal_amd64.deb"

# Alacritty
sudo add-apt-repository ppa:aslatter/ppa 

echo "Updating system"
sudo apt update
sudo apt -y upgrade 

echo "Installing packages"
cat packages.txt | xargs sudo apt -y install

sudo snap install spotify
sudo snap install code --classic
sudo snap install docker

# Setup vim
echo "Setting up vim"

# https://github.com/junegunn/vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
vim +PlugInstall

cd ~/.vim/plugged/YouCompleteMe
python3 install.py --ts-completer --go-completer
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
    wget -P /tmp "https://d2t3ff60b2tol4.cloudfront.net/builds/$INSYNC"
    sudo dpkg -i "/tmp/$INSYNC"
fi

# Download and run Jetbrains Toolbox
echo "Setting up Jetbrains Toolbox"
wget -P /tmp https://download.jetbrains.com/toolbox/$TOOLBOX
tar -xvzf /tmp/"$TOOLBOX" -C "$IDEDIR/"
sh "$IDEDIR/$TOOLBOX"/jetbrans-toolbox
