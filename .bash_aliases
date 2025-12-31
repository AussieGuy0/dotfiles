is_bin_in_path() {
    builtin type -P "$1" &> /dev/null
}

update_nix() {
    cd ~/.config/home-manager
    nix flake update
    NIXPKGS_ALLOW_UNFREE=1 home-manager switch --impure --flake .
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $HOME/.nix-profile/bin/ghostty 50
    nix-collect-garbage -d
    cd -
}

# Allow system-specific aliases (e.g. work aliases)
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
alias gro='git reset --hard @{u}' # Reset local branch to match remote

alias fly='flyctl'

alias gho='git --work-tree=$HOME --git-dir=$HOME/.home'
alias ghod='git --work-tree=$HOME --git-dir=$HOME/.home add -f'

alias cljrepl='clj -Sdeps '\''{:deps {nrepl/nrepl {:mvn/version "1.0.0"} cider/cider-nrepl {:mvn/version "0.42.1"}}}\'\'' \
    --main nrepl.cmdline \
    --middleware '\''["cider.nrepl/cider-middleware"]'\'' \
    --interactive'

alias aka-edit='vim ~/.bash_aliases && . ~/.bash_aliases'

alias nix-update='update_nix'
alias nix-edit='vim  ~/.config/home-manager/home.nix'

if is_bin_in_path eza
then
    alias ls='eza'
fi
