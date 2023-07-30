# dotfiles
My personal dotfiles, use at own risk!

Inspired by https://drewdevault.com/2019/12/30/dotfiles.html.

I utilise the arguments `--work-tree` and `--git-dir` when working in the git directory in the home
directory. This means that normal `git` commands won't treat the home directory as a git directory,
unless you specify those arguments. I provide an alias `gho` which should be used when interacting
with dotfiles in the home directory.

## Installation
```sh
# This makes next commands a bit easier.
alias gho='git --work-tree=$HOME --git-dir=$HOME/.home'

cd ~
gho init
gho remote add origin git@github.com:AussieGuy0/dotfiles.git
gho fetch
gho checkout -f master
./scripts/setup.sh
```

## Adding new files
```sh
gho add -f .file
```

## Syncing dotfiles from remote
```sh
updots
```
