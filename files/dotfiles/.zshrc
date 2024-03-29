#  Source Prezto first
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
    source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

#  Load zshrc.d files
if [ -d $HOME/.dotfiles/zshrc.d ]; then
    for file in $HOME/.dotfiles/zshrc.d/*.zsh; do
        source $file
    done
fi

#  Load rc.d files
if [ -d $HOME/.dotfiles/rc.d ]; then
    for file in $HOME/.dotfiles/rc.d/*.sh; do
        source $file
    done
fi

#
# pyenv
#
if command -v pyenv &>/dev/null; then
    eval "$(pyenv init -)"
fi
if command -v pyenv-virtualenv &>/dev/null; then
    eval "$(pyenv virtualenv-init -)"
fi
