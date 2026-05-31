# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

HISTFILESIZE=100000
HISTSIZE=10000

shopt -s histappend
shopt -s extglob
shopt -s globstar
shopt -s checkjobs

# Bash completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

# PATH
export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.fly/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"

# Environment
export EDITOR="vim"
export BROWSER="firefox"
export TERMINAL="ghostty"

# Aliases
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# mise
eval "$(~/.local/bin/mise activate bash 2>/dev/null || true)"

# fzf
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --bash)"
fi

# starship
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi
