is_bin_in_path() {
    builtin type -P "$1" &> /dev/null
}

alias repos='cd ~/dev/repos/'
alias cd..='cd ..'
alias diary='vim -c +VimwikiMakeDiaryNote'
alias diaryi='vim -c +VimwikiDiaryIndex'
alias wiki='vim -c +VimwikiIndex'

alias vim='nvim'
alias vimpls='\vim'

alias g='git'
alias gds='git diff --staged'


if is_bin_in_path exa
then
    alias ls='exa'
fi
