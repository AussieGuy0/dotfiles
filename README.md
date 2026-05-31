# dotfiles
My personal dotfiles, use at own risk!

Inspired by https://drewdevault.com/2019/12/30/dotfiles.html.

I utilise the arguments `--work-tree` and `--git-dir` when working in the git directory in the home
directory. This means that normal `git` commands won't treat the home directory as a git directory,
unless you specify those arguments. I provide an alias `gho` which should be used when interacting
with dotfiles in the home directory.

## Installation
```sh
sudo apt install curl git
# This makes the next commands look nicer.
alias gho='git --work-tree=$HOME --git-dir=$HOME/.home'

cd ~
gho init
gho remote add origin git@github.com:AussieGuy0/dotfiles.git
gho fetch
gho checkout -f master
./scripts/setup.sh
```

## Package management

- **Language runtimes** (node, go, rust, java, deno, etc.) are managed by [mise](https://mise.jdx.dev/) via `~/.config/mise/config.toml`
- **System packages** are managed by apt
- **CLI tools** (eza, zellij) are installed via cargo

### Updating

```sh
mise-update   # upgrade mise-managed tools
sudo apt upgrade
```

### Editing mise tools

```sh
mise-edit   # opens ~/.config/mise/config.toml
```

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
