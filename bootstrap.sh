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

I know, that logo was cheesy.... but anyways.

Whenever you are ready, press enter (or Ctrl+C, if you changed your mind) and let the installer run.

Be forewarned that this installer is intended for a "virgin" machine with nothing yet configured on it.

Be prepared, as well, to enter your password --when needed-- so that it can perform root-level tasks.

Once the installer has finished, a reboot is in order.

With the above being said: sit back, relax and let the machine do the "brunt" of the work for you.

EOF
    read -p "Press [Enter] to continue... " -n1 -s
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
    download_and_run_repo
}

install
