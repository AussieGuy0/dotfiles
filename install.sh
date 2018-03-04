#!/bin/bash
############################
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# Initially from https://github.com/skywinder/dotfiles/blob/master/makesymlinks.sh
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="gitconfig vimrc"    # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir || return
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    #check, that file is not sym-link to our file:
    sym_path=$(eval "readlink ~/.$file")
    subpath=$(echo $dir)

    if [[ -n "$sym_path"  && $sym_path == "$subpath"* ]] 
    then
        echo "$file already linked -> skip"
        continue
    fi
    if [[ -e ~/.$file ]]
    then
        echo "Moving .$file to $olddir"
        mv ~/.$file ~/dotfiles_old/
    fi
    echo "Creating symlink to .$file in home directory."
    ln -s $dir/$file ~/.$file
done


echo "Done"
