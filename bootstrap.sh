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
#  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/MarkAWard/prime-my-mac/master/bootstrap.sh)"
#
#  Use the `bash -c "$(curl ...)"` pattern — piping `curl | bash` disconnects
#  stdin from the terminal, which breaks any `read` prompts and makes the
#  Homebrew installer skip its Xcode CLT wait step.
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


function install_xcode_cli {
    #
    #  Install Xcode Command Line Tools and BLOCK until they're actually
    #  on disk. We need `git` before we can clone the repo; brew's
    #  installer can trigger the CLT GUI prompt but doesn't wait for it
    #  to finish, so we do the install + wait explicitly here.
    #
    if xcode-select -p > /dev/null 2>&1; then
        return
    fi

    echo "Installing Xcode Command Line Tools..."
    osascript -e "display notification \"Click Install in the Xcode CLT dialog — prime-my-mac will resume when it's done\" with title \"prime-my-mac\" subtitle \"...\""
    xcode-select --install > /dev/null 2>&1

    echo "Waiting for the Xcode CLT install to complete (click Install in the dialog, then wait)..."
    local waited=0
    local max_wait=1200   # 20 minutes
    until xcode-select -p > /dev/null 2>&1; do
        if [ "$waited" -ge "$max_wait" ]; then
            echo "Error: Xcode CLT did not finish installing within ${max_wait}s."
            echo "If you cancelled the dialog, re-run bootstrap.sh to try again."
            exit 1
        fi
        sleep 10
        waited=$((waited + 10))
    done
    echo "Xcode Command Line Tools installed."
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
