# dotfiles
My personal dotfiles, use at own risk!

Inspired by https://drewdevault.com/2019/12/30/dotfiles.html.

I utilise the arguments `--work-tree` and `--git-dir` when working in the git directory in the home
directory. This means that normal `git` commands won't treat the home directory as a git directory,
unless you specify those arguments. I provide an alias `gho` which should be used when interacting
with dotfiles in the home directory.

## Installation
```sh
# This makes the next commands look nicer.
alias gho='git --work-tree=$HOME --git-dir=$HOME/.home'

cd ~
gho init
gho remote add origin git@github.com:AussieGuy0/dotfiles.git
gho fetch
gho checkout -f master
./scripts/setup.sh
```

### Installation using Nix (experimental)
1. Install Nix (https://nixos.org/download#nix-install-linux)
2. Install Home Manager
   (https://nix-community.github.io/home-manager/index.html#sec-install-standalone)
3. Run `home-manager switch`


## Adding new files
```sh
ghod .file
# or
# gho add -f .file
```

## Syncing dotfiles from remote
```sh
updots
```
