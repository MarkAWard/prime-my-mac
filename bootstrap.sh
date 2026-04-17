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
#  curl -fsSL https://raw.githubusercontent.com/markaward/prime-my-mac/master/bootstrap.sh | bash
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
    #  Bootstrap Homebrew on a virgin Mac. Runs before libs/ are sourced,
    #  so it can't depend on helpers like status_msg. Triggers the Xcode
    #  Command Line Tools installer as a side effect, which gives us git
    #  for the clone step below.
    #
    if ! command -v brew > /dev/null 2>&1; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # On Apple Silicon brew installs to /opt/homebrew and isn't on PATH
        if [ -x /opt/homebrew/bin/brew ]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "${HOME}/.zprofile"
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        brew doctor
    fi
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

    if [ -d "$TMP_DIR/.git" ]; then
        cd "$TMP_DIR" && git pull > /dev/null 2>&1
    else
        rm -rf "$TMP_DIR"
        git clone "$GIT_REPO" "$TMP_DIR"
    fi

    cd "$TMP_DIR" && ./install.sh --all
}


function install {
    warning_message
    install_xcode_cli
    download_and_run_repo
}


install
