is_bin_in_path() {
    builtin type -P "$1" &> /dev/null
}

[ -s "$HOME/.bash_local_aliases" ] && \. "$HOME/.bash_local_aliases"

alias repos='cd ~/dev/repos/'
alias cd..='cd ..'

alias diary='vim -c +VimwikiMakeDiaryNote'
alias diaryi='vim -c +VimwikiDiaryIndex'
alias wiki='vim -c +VimwikiIndex'

alias vim='nvim'
alias vimpls='\vim'

alias g='git'
alias gp='git push'
alias gd='git diff'
alias gds='git diff --staged'

alias fly='~/.fly/bin/flyctl'

if is_bin_in_path exa
then
    alias ls='exa'
fi
