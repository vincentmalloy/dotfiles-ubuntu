
# If you come from bash you might have to change your $PATH.
export PATH="$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH"
export EDITOR='hx'
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
plugins=(
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-fzf-history-search
    vscode
    web-search
    copyfile
    copybuffer
    history
    direnv
)

source $ZSH/oh-my-zsh.sh

# init oh-my-posh
eval "$(oh-my-posh init zsh --config ~/.dotfiles/omptheme/omptheme.json)"
eval $(thefuck --alias fuck)

# dir colors
export EXA_COLORS="da=38;5;240:sn=38;5;240:sb=38;5;240"

# options
setopt HIST_IGNORE_ALL_DUPS
unsetopt HIST_IGNORE_DUPS
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
