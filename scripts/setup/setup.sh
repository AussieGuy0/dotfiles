#!/bin/bash
DEVPATH="$HOME/Documents/dev"
IDEDIR="$DEVPATH/ide" 
EMAIL="anthony.bruno196@gmail.com"
USERNAME="AussieGuy0"


sudo apt-get install update
sudo apt-get install upgrade

# Needed to use some formats like MP3
sudo apt-get install ubuntu-restricted-extras 

sudo apt-get install git
git config --global user.email "$EMAIL"
git config --global user.name "$USERNAME"

# Install java
sudo apt-get install openjdk-8-jdk
sudo apt-get install openjdk-8-doc

sudo apt-get install i3
sudo apt-get install i3blocks


# Vim Setup
sudo apt-get install vim


git clone https://github.com/AussieGuy0/dotfiles.git "$DEVPATH"
cp "$DEVPATH/dotfiles/.vimrc" "$HOME"

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall


# Linters
sudo apt-get install shellcheck
sudo apt-get install flake8

# Downloads IntelliJ
wget -P "$IDEDIR" https://download.jetbrains.com/idea/ideaIU-2016.1.4.tar.gz
tar -xvzf "$IDEDIR/ideaIU-2016.1.4.tar.gz"

# Spotify

# 1. Add the Spotify repository signing key to be able to verify downloaded packages
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886

# 2. Add the Spotify repository
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

# 3. Update list of available packages
sudo apt-get update

# 4. Install Spotify
sudo apt-get install spotify-client
