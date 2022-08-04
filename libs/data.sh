#!/usr/bin/env bash

#
#  D A T A . S H
#

declare pyenv_versions=(
    2.7.18
    3.6.15
    3.7.13
    3.8.13
    3.9.13
    3.10.5
)
declare pyenv_global=3.9.13

#  pip packages
declare pip_pkgs=(
    awscli                            #  AWS CLI
    black                             #  Uncompromising code formatter
    boto3                             #  AWS SDK
    bump2version                      #  Code versioning via cmd-line
    docker                            #  Docker python lib
    json2yaml                         #  YAML for the win!
    mypy                              #  Python static type checker
    pre-commit                        #  Pre-commits git hooks
    pygments                          #  File colorization from terminal
    pylint                            #  Python linter
    shyaml                            #  YAML parser
    virtualenv                        #  Virtual environments
)

#  homebrew packages
declare brew_pkgs=(
    bash                              #  Bash 4.x
    bash-completion
    bat                               #  cat replacement
    colordiff                         #  Add to .zprofile
    coreutils
    dockutil                          #  Manage the OS X Dock
    emacs
    exa                               #  'ls' on steroids
    findutils                         #  Add to .zprofile
    fzf                               #  fuzzy finder
    gh                                #  github cli
    git
    git-delta
    gnu-getopt                        #  Use linux getopt; add to .zprofile
    gnu-indent                        #  Use linux indent; add to .zprofile
    gnu-sed                           #  Use linux sed; add to .zprofile
    gnu-tar                           #  Use linux tar; add to .zprofile
    grc
    grep
    htop
    jq                                #  JSON parser
    kubectx                           #  Switch kubernetes context
    kubernetes-cli                    #  Kubernetes CLI
    netcat
    openssl
    pv                                #  Shell progress bar monitor
    pyenv
    readline
    sqlite3
    terminal-notifier                 #  OS X notifications via shell
    trash                             #  Send deleted files to OSX trash
    tree
    watch                             #  Linux "watch" command
    wget                              #  Linux "wget" command
    xz
    yq                                #  YML parser
    zlib
)

#  homebrew cask packages
#  :l == laptop-only, :u == "Utilities" folder-only
declare cask_pkgs=(
    1password
    dbeaver-community
    docker
    google-chrome
    iterm2
    lens
    postman
    rectangle
    spotify
    temurin
    visual-studio-code
)


declare cask_fonts=(
    dejavu-sans-mono-for-powerline
    inconsolata-for-powerline
    menlo-for-powerline
    monofur-for-powerline
    quantico
    roboto
    roboto-mono
    roboto-mono-for-powerline
    source-code-pro
    ubuntu
    ubuntu-mono-derivative-powerline
)


#  Dock Apps
declare dock_apps=(
    'Launchpad:sys'
    'Calculator:sys'
    '--'
    'Google Chrome'
    'Visual Studio Code'
    'iTerm'
    'DBeaver'
    'Spotify'
    '--'
    'Activity Monitor:util'
    'System Preferences:sys'
)

#  Dock Folders
## FolderName:sort-order
declare dock_folders=(
    '~/Downloads:dateadded'
    '/Applications:name'
)


#  VS Code extensions
declare vscode_extensions=(
    'aaron-bond.better-comments'
    'bungcip.better-toml'
    'christian-kohler.path-intellisense'
    'eamodio.gitlens'
    'fabiospampinato.vscode-diff'
    'hashicorp.terraform'
    'ms-azuretools.vscode-docker'
    'ms-python.python'
    'ms-toolsai.jupyter'
    'ms-vscode-remote.remote-containers'
    'mtxr.sqltools'
    'pkief.material-icon-theme'
    'ryu1kn.partial-diff'
    'ryu1kn.text-marker'
    'shd101wyy.markdown-preview-enhanced'
    'tyriar.sort-lines'
    'VisualStudioExptTeam.vscodeintellicode'
    'vscode-icons-team.vscode-icons'
    'wayou.vscode-todo-highlight'
    'wmaurer.change-case'
)
