#!/usr/bin/env bash

#
#  B O O T S T R A P . S H
#
#  =============================================================================
#
#  Install XCode CLI Tools
#  Download repo and run install
#
#  To install:
#  curl -fsSL https://github.com/markaward/prime-my-mac/bootstrap.sh | bash
#
#  Original source from https://github.com/ifarfan/prime-my-mac


#  Variables
REPO_NAME=prime-my-mac
TMP_DIR=${HOME}/.${REPO_NAME}
GIT_REPO=https://github.com/markaward/${REPO_NAME}.git


function warning_message {
cat << EOF
            .:'
        __ :'__
     .'\`  \`-'  \`\`.
    :          .-'
    :         :
     :         \`-;
      \`.__.-.__.'


.: PRIME-MY-MAC :.


Whenever you are ready, press enter (or Ctrl+C, if you changed your mind) and let the installer run.

Be forewarned that this installer is intended for a "virgin" machine with nothing yet configured on it.

Be prepared, as well, to enter your password --when needed-- so that it can perform root-level tasks.

Once the installer has finished, a reboot is in order.

With the above being said: sit back, relax and let the machine do the "brunt" of the work for you.

EOF
    read -p "Press [Enter] to continue... " -n1 -s
}


function install_homebrew {
    #
    #  http://brew.sh/
    #
    local BREW_ERR_CODE=$(command -v brew > /dev/null 2>&1; echo $?)
    status_msg "$BREW_ERR_CODE" "homebrew"
    if [ "$BREW_ERR_CODE" -ne 0 ]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            # On Apple Silicon brew is not placed on the default PATH
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
            brew doctor
    fi

    #  Copy aggresive .curl file to optimize brew installs
    cp -n "./files/dotfiles/.curl" "${HOME}/.curl"


}

function install_xcode_cli {
    XCODE_ERR_CODE=$(xcode-select -p > /dev/null 2>&1; echo $?)

    if [ "$XCODE_ERR_CODE" -ne 0 ]; then
        echo "Installing XCode Command Line Tools..."
        osascript  -e "display notification \"Installing XCode Command Line Tools...\" with title \"prime-my-mac\"  subtitle \"...\""

        #
        # Homebrew will install xcode if it detects it is missing
        # https://www.freecodecamp.org/news/install-xcode-command-line-tools/
        #
        install_homebrew

        #
        #  Trick "softwareupdate" into assuming that we were installing the CLI tool before and it will attempt to continue
        #  With lots of help from https://github.com/timsutton/osx-vm-templates/blob/master/scripts/xcode-cli-tools.sh
        #
        # touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
        # XCODE_CLT_VER=$(softwareupdate --list | grep "\*.*Command Line" | tail -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n')
        # softwareupdate --install "$XCODE_CLT_VER" --verbose
        # rm -rf /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    fi
}


function download_and_run_repo {
    #
    #  Download repo and run install
    #
    osascript  -e "display notification \"Downloading git repo and running install...\" with title \"prime-my-mac\"  subtitle \"...\""

    [[ -d "$TMP_DIR" ]] && cd $TMP_DIR && git pull > /dev/null 2>&1 || git clone ${GIT_REPO} $TMP_DIR/
    cd $TMP_DIR && ./install.sh --all
}


function install {
    warning_message
    install_xcode_cli
    download_and_run_repo
}


install
