# dotfiles
My personal dotfiles, use at own risk!

Inspired by https://drewdevault.com/2019/12/30/dotfiles.html

## Installation
```sh
cd ~
git init
git remote add origin git@github.com:AussieGuy0/dotfiles.git
git fetch
git checkout -f master
./scripts/setup.sh
```

## Adding new files
```sh
git add -f .file
```

## Syncing dotfiles from remote
```sh
updots
```
