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

# User-local bin (pipx, uv tool installs, etc.)
export PATH="$HOME/.local/bin:$PATH"

# Python TLS: point requests/urllib at Homebrew's CA bundle so HTTPS calls
# don't fail with CERTIFICATE_VERIFY_FAILED (Python can't read macOS's
# system trust store directly).
export REQUESTS_CA_BUNDLE=/opt/homebrew/etc/ca-certificates/cert.pem
export SSL_CERT_FILE=/opt/homebrew/etc/ca-certificates/cert.pem

# golang
if command -v go &>/dev/null; then
    export GOPATH=$HOME/go
    export GOROOT="$(brew --prefix golang)/libexec"
    export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
fi


# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# bun — globally-installed CLIs land in ~/.bun/bin
export PATH="$HOME/.bun/bin:$PATH"
