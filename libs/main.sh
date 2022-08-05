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

#  Determine if it's a laptop
#  SEE: http://arstechnica.com/civis/viewtopic.php?f=19&t=1118530
[[ "$(sysctl -n hw.model | grep -q -i book; echo $?)" -eq 0 ]] && IS_LAPTOP=true || IS_LAPTOP=false

#  Determine OS minor version
#  SEE: https://coderwall.com/p/4yz8dq/determine-os-x-version-from-the-command-line
OS_MINOR=$(defaults read loginwindow SystemVersionStampAsString | cut -d'.' -f2)

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
    [ "$BREW_ERR_CODE" -ne 0 ] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    #  Copy aggresive .curl file to optimize brew installs
    cp -n "./files/dotfiles/.curl" "${HOME}/.curl"
}


function install_python {
    install_homebrew

    local PYENV_ERR_CODE=$(brew list --formula | grep -q pyenv$; echo $?)
    status_msg "$PYENV_ERR_CODE" "pyenv"
    if [ "${PYENV_ERR_CODE}" -ne 0 ]; then
        #  Install latest version of pyenv
        brew install pyenv
        status_msg "0" "pyenv"
    fi
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"

    #  Install python versions
    status_msg "Installing python versions"
    for ver in "${pyenv_versions[@]}"; do
        pyenv install -s $ver
    done
    pyenv global $pyenv_global
    status_msg "0" "python versions"

    #  Install pip packages
    status_msg "Installing pip packages"
    pip install -qq -U pip
    for pkg in "${pip_pkgs[@]}"; do
        pip install $pkg --quiet
    done
    status_msg "0" "pip packages"

    local PYENVVENV_ERR_CODE=$(brew list --formula | grep -q pyenv-virtualenv$; echo $?)
    status_msg "$PYENVVENV_ERR_CODE" "pyenv-virtualenv"
    if [ "${PYENVVENV_ERR_CODE}" -ne 0 ]; then
        #  Install latest version of pyenv
        brew install pyenv-virtualenv
        status_msg "0" "pyenv-virtualenv"
    fi
    eval "$(pyenv virtualenv-init -)"
}


function install_brew {
    install_homebrew
    git -C $(brew --repository homebrew/core) checkout master

    #  Install packages
    status_msg "Installing brew packages"
    for pkg in "${brew_pkgs[@]}"; do
        brew install ${pkg}
    done
    status_msg "0" "brew packages"
}


function install_brew_cask {
    install_homebrew

    #  Install cask packages
    brew tap homebrew/cask
    git -C $(brew --repository homebrew/cask) checkout master
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

function install_brew_fonts {
    install_homebrew

    status_msg "Installing cask fonts"

    #  A few fonts still run under svn
    brew install svn

    #  Install cask fonts
    brew tap homebrew/cask-fonts
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

        #  Install prezto + change shell to zsh
        git clone --recursive https://github.com/sorin-ionescu/prezto.git ${HOME}/.zprezto
        rcfiles=(${HOME}/.zprezto/runcoms/z*)
        for rcfile in "${rcfiles[@]}"; do
            ln -s "$rcfile" "${HOME}/.${rcfile##*/}"
        done
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
        ${HOME}/.bash_it/install.sh
    fi
    chsh -s /bin/bash

    #  Install Docker autocomplete
    for d in docker docker-compose; do
        ln -s "/Applications/Docker.app/Contents/Resources/etc/${d}.bash-completion" "/usr/local/etc/bash_completion.d/${d}.bash-completion"
    done

    status_msg "0" "bash-it"
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
    #  git
    #
    cp -R ./files/git "${HOME}/.git"
    for g_file in ./files/git/.*; do
        gitfile=$(basename ${g_file})
        ln -sf "${HOME}/.git/${gitfile}" "${HOME}/${gitfile}"
    done
    status_msg "0" "Git configs"

    #
    #  Activate .dotfiles
    #
    cp -R ./files/dotfiles "${HOME}/.dotfiles"
    for d_file in ./files/dotfiles/.*; do
        dotfile=$(basename ${d_file})
        ln -sf "${HOME}/.dotfiles/${dotfile}" "${HOME}/${dotfile}"
    done
    status_msg "0" "Dot-files"

}
