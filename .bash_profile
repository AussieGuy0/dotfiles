export PATH=~/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$PATH
export EDITOR="vim"

export NVM_DIR="$HOME/dev/tools/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"

export FLYCTL_INSTALL="/home/anthony/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# Added by Toolbox App
export PATH="$PATH:/home/anthony/.local/share/JetBrains/Toolbox/scripts"
