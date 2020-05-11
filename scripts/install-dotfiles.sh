#!/bin/bash
############################
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# Initially from https://github.com/skywinder/dotfiles/blob/master/makesymlinks.sh
############################

########## Variables

currdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$currdir"/.. || exit
dir=$(pwd)
files=".gitconfig .vimrc .vim .npmrc .bash_aliases .bash_profile .tmux.conf bin"    # list of files/folders to symlink in homedir

##########

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd "$dir" || return
echo "done"

for file in $files; do
    #check, that file is not sym-link to our file:
    sym_path=$(eval "readlink ~/$file")
    subpath=$dir

    if [[ -n "$sym_path"  && $sym_path == "$subpath"* ]] 
    then
        echo "$file already linked -> skip"
        continue
    fi
    echo "Creating symlink to $file in home directory."
    ln -s "$dir/$file" ~/"$file"
done


echo "Done"
