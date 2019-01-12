#!/bin/bash
DEVPATH="$HOME/dev"
IDEDIR="$DEVPATH/ide" 

sudo apt update
sudo apt -y upgrade 

cat packages.txt | xargs sudo apt -y install

sudo snap install node --classic --channel=10
sudo snap install spotify

git clone https://github.com/AussieGuy0/dotfiles.git "$DEVPATH"
cp "$DEVPATH/dotfiles/.vimrc" "$HOME"

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# Downloads IntelliJ
wget -P "$IDEDIR" https://download.jetbrains.com/idea/ideaIU-2018.3.3.tar.gz
tar -xvzf "$IDEDIR/ideaIU-2018.3.3.tar.gz"
