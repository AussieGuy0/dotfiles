[ -f /etc/bash.bashrc ] && . /etc/bash.bashrc

export EDITOR=vim
export BROWSER=firefox
export TERMINAL=ghostty

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# mise - dev tools version manager
if [ -f "$HOME/.local/bin/mise" ]; then
    eval "$($HOME/.local/bin/mise activate bash)"
fi

[ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"

# fzf key bindings (installed via apt)
[ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && . /usr/share/doc/fzf/examples/key-bindings.bash
[ -f /usr/share/doc/fzf/examples/completion.bash ] && . /usr/share/doc/fzf/examples/completion.bash
