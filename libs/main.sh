#!/usr/bin/env bash

#
#  M A I N . S H
#


#  Colors
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

#  Homebrew settings
export HOMEBREW_VERBOSE=0
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1

#  Determine if it's a laptop (used by install_brew_cask for :l attribute)
#  SEE: http://arstechnica.com/civis/viewtopic.php?f=19&t=1118530
[[ "$(sysctl -n hw.model | grep -q -i book; echo $?)" -eq 0 ]] && IS_LAPTOP=true || IS_LAPTOP=false

function status_msg {
    #
    #  Print package install status
    #
    timestamp=$(date +"%F %T")
    if [[ $# -eq 1 ]]; then
        echo "[$timestamp] ${CYAN}$1${NORMAL}";
    elif [[ "$1" == "ALERT" ]]; then
        echo "[$timestamp] ${CYAN}$2${NORMAL}";
        osascript \
            -e "on run(argv)" \
            -e "  return display notification \"[$timestamp] \" & item 1 of argv with title \"prime-my-mac\"  subtitle \"...\"" \
            -e "end" \
            -- "$2"
    elif [[ "$1" -ne 0 ]]; then
        echo "[${BOLD}${RED}N${NORMAL}] Installing ${BLUE}$2${NORMAL}..."
        osascript \
            -e "on run(argv)" \
            -e "  return display notification \"Installing \" & item 1 of argv with title \"prime-my-mac\"  subtitle \"...\"" \
            -e "end" \
            -- "$2"
    else
        echo "[${BOLD}${GREEN}Y${NORMAL}] ${BLUE}$2${NORMAL} installed"
        osascript \
            -e "on run(argv)" \
            -e "  return display notification item 1 of argv & \" installed\" with title \"prime-my-mac\"  subtitle \"...\"" \
            -e "end" \
            -- "$2"
    fi
}


function install_homebrew {
    #
    #  http://brew.sh/
    #
    local BREW_ERR_CODE=$(command -v brew > /dev/null 2>&1; echo $?)
    status_msg "$BREW_ERR_CODE" "homebrew"
    if [ "$BREW_ERR_CODE" -ne 0 ]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        #  On Apple Silicon brew installs to /opt/homebrew and isn't on PATH
        if [ -x /opt/homebrew/bin/brew ]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "${HOME}/.zprofile"
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi
}


function install_python {
    install_homebrew

    #  pyenv is also listed in brew_pkgs, but install_python runs before
    #  install_brew (see install.sh), so we need pyenv available here first.
    #  The brew_pkgs entry is a no-op on re-runs.
    local PYENV_ERR_CODE=$(brew list --formula | grep -q pyenv$; echo $?)
    status_msg "$PYENV_ERR_CODE" "pyenv"
    if [ "${PYENV_ERR_CODE}" -ne 0 ]; then
        brew install pyenv
        status_msg "0" "pyenv"
    fi
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"

    #  Python build dependencies. These are also in brew_pkgs, but we install
    #  them here too so `--python` can be run standalone. `brew install` on
    #  already-installed formulae is near-instant (just prints a notice).
    status_msg "Ensuring Python build dependencies"
    brew install openssl@3 readline sqlite xz zlib ca-certificates
    status_msg "0" "Python build dependencies"

    #  Install python versions (-s skips already-installed)
    status_msg "Installing python versions"
    for ver in "${pyenv_versions[@]}"; do
        pyenv install -s $ver
    done
    pyenv global $pyenv_global
    pyenv rehash
    status_msg "0" "python versions"

    #  Install pip packages into the pyenv_global interpreter
    status_msg "Installing pip packages"
    python -m pip install --upgrade --quiet pip
    for pkg in "${pip_pkgs[@]}"; do
        python -m pip install --upgrade --quiet $pkg
    done
    pyenv rehash   # make new CLI shims (ruff, ipython, black...) available
    status_msg "0" "pip packages"

    local PYENVVENV_ERR_CODE=$(brew list --formula | grep -q pyenv-virtualenv$; echo $?)
    status_msg "$PYENVVENV_ERR_CODE" "pyenv-virtualenv"
    if [ "${PYENVVENV_ERR_CODE}" -ne 0 ]; then
        brew install pyenv-virtualenv
        status_msg "0" "pyenv-virtualenv"
    fi
    eval "$(pyenv virtualenv-init -)"
}


function install_node {
    install_homebrew

    #  nvm is also in brew_pkgs, but install_node runs before install_brew,
    #  so pull it in early. The brew_pkgs entry is a no-op on re-runs.
    local NVM_ERR_CODE=$(brew list --formula | grep -q '^nvm$'; echo $?)
    status_msg "$NVM_ERR_CODE" "nvm"
    if [ "${NVM_ERR_CODE}" -ne 0 ]; then
        brew install nvm
        status_msg "0" "nvm"
    fi

    #  brew doesn't create ~/.nvm for us — nvm expects it to exist
    export NVM_DIR="$HOME/.nvm"
    [ -d "$NVM_DIR" ] || mkdir -p "$NVM_DIR"
    . "$(brew --prefix nvm)/nvm.sh"

    #  Install the current LTS and pin as the default version
    status_msg "Installing Node LTS"
    nvm install --lts
    nvm alias default 'lts/*'
    status_msg "0" "Node LTS"
}


function install_brew {
    install_homebrew

    #  Install packages
    status_msg "Installing brew packages"
    for pkg in "${brew_pkgs[@]}"; do
        brew install ${pkg}
    done
    status_msg "0" "brew packages"
}


function install_brew_cask {
    install_homebrew

    #  Install cask packages (homebrew-cask is bundled into core since 2019;
    #  no explicit `brew tap` needed)
    status_msg "Installing cask packages"
    for pkg in "${cask_pkgs[@]}"; do

        if [[ ${pkg} =~ ":" ]]; then
            #  Get package extra-attributes
            pkg_name=$(echo ${pkg}   | cut -d ':' -f1)
            pkg_atribs=$(echo ${pkg} | cut -d ':' -f2)

            if [[ ${pkg_atribs} =~ "l" ]]; then
                # Laptop only packages
                [[ $IS_LAPTOP == true ]] && brew install --cask ${pkg_name}
            else
                brew install --cask ${pkg_name}
            fi
        else
            #  Standard package
            brew install --cask ${pkg}
        fi
    done
    status_msg "0" "cask packages"
}

function install_github_auth {
    #
    #  Interactive GitHub auth via `gh`. Replaces the old pattern of
    #  committing a plaintext token in ~/.git/.gitconfig.github. `gh auth
    #  setup-git` wires gh in as a git credential helper so cloning/pushing
    #  over HTTPS Just Works.
    #
    if ! command -v gh >/dev/null 2>&1; then
        status_msg "ALERT" "gh not found — run --brew first, then --github"
        return
    fi

    if gh auth status >/dev/null 2>&1; then
        status_msg "0" "GitHub already authenticated"
        return
    fi

    status_msg "Authenticating with GitHub (interactive)"
    gh auth login
    gh auth setup-git
    status_msg "0" "GitHub auth"
}


function install_brew_fonts {
    install_homebrew

    #  homebrew/cask-fonts was merged into homebrew-cask core in 2024; font
    #  casks live under the main `font-*` names and install cleanly via http.
    status_msg "Installing cask fonts"
    for font in "${cask_fonts[@]}"; do
        brew install --cask font-$font
    done
    status_msg "0" "cask fonts"
}

function install_prezto {
    status_msg "prezto"

    if [ -d "${HOME}/.zprezto" ]; then

        pushd . > /dev/null 2>&1        #  Mark location
        cd "${HOME}/.zprezto" && git fetch --all && git reset --hard origin/master && git submodule update --init --recursive
        popd > /dev/null 2>&1           #  Return to project root
    else
        status_msg "1" "prezto"

        #  Install prezto + change shell to zsh. install_dotfiles will
        #  overwrite the z* runcoms afterwards with the repo's own copies,
        #  so no need to pre-symlink prezto's defaults here.
        git clone --recursive https://github.com/sorin-ionescu/prezto.git ${HOME}/.zprezto
        chsh -s /bin/zsh
    fi

    status_msg "0" "prezto"
}

function install_bash_it {
    status_msg "bash-it"

    if [ -d "${HOME}/.bash_it" ]; then
        bash-it update
    else
        status_msg "1" "bash-it"

        git clone --depth=1 https://github.com/Bash-it/bash-it.git ${HOME}/.bash_it
        #  --silent enables bash-it's default set of aliases/plugins/completions
        #  and skips the interactive prompt that would otherwise hang --all runs.
        ${HOME}/.bash_it/install.sh --silent
    fi

    #  Don't flip the login shell — zsh (set by install_prezto) stays default.
    #  bash-it is available when the user opens a bash session explicitly; if
    #  they want bash as the login shell, they can run:  chsh -s /bin/bash
    status_msg "0" "bash-it (login shell unchanged; run 'chsh -s /bin/bash' to switch)"
}


function install_dotfiles {
    status_msg "Installing dot files"
    #
    #  dircolors
    #
    if [ -f "${HOME}/.dircolors" ]; then
        pushd . > /dev/null 2>&1
        cd "${HOME}/.dircolors-solarized" && git fetch --all && git reset --hard origin/master
        popd > /dev/null 2>&1
    else
        status_msg "1" "dircolors"
        git clone --recursive https://github.com/seebi/dircolors-solarized.git ${HOME}/.dircolors-solarized
        ln -s "${HOME}/.dircolors-solarized/dircolors.256dark" "${HOME}/.dircolors"
    fi
    status_msg "0" "dircolors"

    #
    #  colorize
    #
    if [ -d "${HOME}/.grc" ]; then
        pushd . > /dev/null 2>&1
        cd "${HOME}/.grc" && git fetch --all && git reset --hard origin/master
        popd > /dev/null 2>&1
    else
        status_msg "1" "colorize"
        git clone https://github.com/garabik/grc.git ${HOME}/.grc
    fi
    status_msg "0" "colorize"

    #
    #  git — stage under XDG-standard ~/.config/git/. Avoid the old ~/.git/
    #  location: git treats $HOME/.git as repo metadata, so any git command
    #  run from $HOME would pick it up as an active repo.
    #
    mkdir -p "${HOME}/.config/git"
    cp -R ./files/git/. "${HOME}/.config/git/"
    ln -sf "${HOME}/.config/git/.gitconfig" "${HOME}/.gitconfig"

    #  Scrub stale symlinks from the previous ~/.git/ staging pattern
    for stale in .gitconfig.user .gitconfig.github .gitconfig.github-sample .gitignore_global; do
        [ -L "${HOME}/${stale}" ] && rm -f "${HOME}/${stale}"
    done

    status_msg "0" "Git configs"

    #
    #  Activate .dotfiles
    #
    # Remove existing .dotfiles directory to ensure clean copy
    rm -rf "${HOME}/.dotfiles"
    cp -R ./files/dotfiles "${HOME}/.dotfiles"
    #  .[!.]* matches .<anything-but-dot>* — skips `.` and `..` that plain
    #  `.*` expands to (which caused noisy `ln: ...: Resource busy` errors)
    for d_file in ./files/dotfiles/.[!.]*; do
        dotfile=$(basename ${d_file})
        ln -sf "${HOME}/.dotfiles/${dotfile}" "${HOME}/${dotfile}"
    done
    status_msg "0" "Dot-files"

}
