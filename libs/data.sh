#!/usr/bin/env bash

#
#  D A T A . S H
#

declare pyenv_versions=(
    3.11.15
    3.12.13
    3.13.13
    3.14.4
)
declare pyenv_global=3.14.4

#  pip packages installed into the pyenv_global interpreter
declare pip_pkgs=(
    black                             #  Opinionated code formatter
    flake8                            #  Python linter (legacy — ruff covers most of this)
    ipython                           #  Interactive Python REPL
    mypy                              #  Static type checker
    ruff                              #  Fast linter + formatter (Rust)
)

#  homebrew packages
declare brew_pkgs=(
    agent-browser                     #  Browser automation CLI for AI agents
    awscli                            #  AWS CLI
    bash                              #  Bash 4.x (macOS ships 3.2)
    bash-completion                   #  Tab completion for bash
    bat                               #  cat with syntax highlighting
    colima                            #  Container runtime (Docker Desktop alternative)
    colordiff                         #  Colorized diff output wrapper
    coreutils                         #  GNU ls/cp/date/readlink/etc (g-prefixed)
    devspace                          #  Develop/deploy/debug apps on k8s
    direnv                            #  Per-directory env loader (sourced in rc.d/direnv.*)
    dockutil                          #  Script the macOS Dock
    emacs                             #  Emacs editor
    eza                               #  Modern ls replacement (maintained fork of exa)
    findutils                         #  GNU find/xargs (gfind, gxargs)
    flyway                            #  Database schema migrations
    fzf                               #  Fuzzy finder
    gh                                #  GitHub CLI
    git                               #  Newer git than Apple's bundled version
    git-delta                         #  Syntax-highlighting pager for git diff
    gnu-getopt                        #  GNU getopt (long-option parsing for shell scripts)
    gnu-sed                           #  GNU sed (gsed — portable -i, \s/\b regex)
    gnu-tar                           #  GNU tar (gtar — --transform, --wildcards)
    gnupg                             #  GPG — commit signing, encryption
    go                                #  Go toolchain (GOPATH/GOROOT exported in .zshrc)
    grc                               #  Generic Colouriser — colorizes command output
    grep                              #  GNU grep (ggrep — -P perl regex)
    helm                              #  Kubernetes package manager
    htop                              #  Interactive process viewer
    jq                                #  JSON query/filter CLI
    k9s                               #  Kubernetes cluster TUI
    kubectx                           #  Switch kubernetes context/namespace
    kubernetes-cli                    #  kubectl
    netcat                            #  TCP/UDP swiss-army knife (nc)
    openssl@3                         #  TLS/crypto lib (pyenv build dep)
    postgresql@14                     #  Postgres 14 server
    postgresql@15                     #  Postgres 15 server
    pinentry-mac                      #  macOS passphrase prompt for GPG
    poetry                            #  Python packaging & dependency manager
    pre-commit                        #  Git pre-commit hook framework
    pv                                #  Pipe viewer — progress bar for shell pipelines
    pyenv                             #  Python version manager
    readline                          #  GNU readline line-editing lib (pyenv build dep)
    redis                             #  Redis server
    skaffold                          #  Kubernetes dev workflow
    sqlite                            #  Embedded SQL database (pyenv build dep)
    stern                             #  Multi-pod kubernetes log tailing
    terminal-notifier                 #  Send macOS notifications from the shell
    tmux                              #  Terminal multiplexer (also used by workmux)
    trash                             #  Move files to macOS Trash instead of rm
    tree                              #  Recursive directory listing as a tree
    uv                                #  Fast Python package/project manager (Rust)
    watch                             #  Re-run a command periodically and display output
    wget                              #  HTTP downloader (recursive fetch)
    raine/workmux/workmux             #  Git worktree + tmux workflow tool (custom tap)
    xz                                #  xz/lzma compression CLI and lib
    yq                                #  YAML query/filter CLI
    zlib                              #  Compression library (pyenv build dep)
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
    'redhat.vscode-yaml'
    'ryu1kn.partial-diff'
    'ryu1kn.text-marker'
    'shd101wyy.markdown-preview-enhanced'
    'tyriar.sort-lines'
    'VisualStudioExptTeam.vscodeintellicode'
    'vscode-icons-team.vscode-icons'
    'wayou.vscode-todo-highlight'
    'wmaurer.change-case'
)


#  iTerm2 settings in plist file
declare iterm_bookmark_settings=(
    "ASCII Anti Aliased|integer|1"
    "Ambiguous Double Width|integer|0"
    "Ansi 0 Color\":\"Blue Component|real|0.1937013864517212"
    "Ansi 0 Color\":\"Green Component|real|0.155759260058403"
    "Ansi 0 Color\":\"Red Component|integer,0"
    "Ansi 1 Color\":\"Blue Component|real|0.1414571404457092"
    "Ansi 1 Color\":\"Green Component|real|0.1084065511822701"
    "Ansi 1 Color\":\"Red Component|real|0.8192697763442993"
    "Ansi 10 Color\":\"Blue Component|real|0.3829848766326904"
    "Ansi 10 Color\":\"Green Component|real|0.3566595613956451"
    "Ansi 10 Color\":\"Red Component|real|0.2767199277877808"
    "Ansi 11 Color\":\"Blue Component|real|0.4385056495666504"
    "Ansi 11 Color\":\"Green Component|real|0.4071767330169678"
    "Ansi 11 Color\":\"Red Component|real|0.3243661820888519"
    "Ansi 12 Color\":\"Blue Component|real|0.5168579816818237"
    "Ansi 12 Color\":\"Green Component|real|0.5096293091773987"
    "Ansi 12 Color\":\"Red Component|real|0.4405802488327026"
    "Ansi 13 Color\":\"Blue Component|real|0.7290843725204468"
    "Ansi 13 Color\":\"Green Component|real|0.3389629721641541"
    "Ansi 13 Color\":\"Red Component|real|0.3479863405227661"
    "Ansi 14 Color\":\"Blue Component|real|0.5636365413665771"
    "Ansi 14 Color\":\"Green Component|real|0.5648583769798279"
    "Ansi 14 Color\":\"Red Component|real|0.5059919357299805"
    "Ansi 15 Color\":\"Blue Component|real|0.8640598058700562"
    "Ansi 15 Color\":\"Green Component|real|0.9579439163208008"
    "Ansi 15 Color\":\"Red Component|real|0.9894341826438904"
    "Ansi 2 Color\":\"Blue Component|real|0.02020875550806522"
    "Ansi 2 Color\":\"Green Component|real|0.5411549210548401"
    "Ansi 2 Color\":\"Red Component|real|0.4497745335102081"
    "Ansi 3 Color\":\"Blue Component|real|0.02348481118679047"
    "Ansi 3 Color\":\"Green Component|real|0.4675142467021942"
    "Ansi 3 Color\":\"Red Component|real|0.6474647521972656"
    "Ansi 4 Color\":\"Blue Component|real|0.7823141813278198"
    "Ansi 4 Color\":\"Green Component|real|0.462659478187561"
    "Ansi 4 Color\":\"Red Component|real|0.1275488436222076"
    "Ansi 5 Color\":\"Blue Component|real|0.4351663589477539"
    "Ansi 5 Color\":\"Green Component|real|0.1080246344208717"
    "Ansi 5 Color\":\"Red Component|real|0.7773894071578979"
    "Ansi 6 Color\":\"Blue Component|real|0.5250227451324463"
    "Ansi 6 Color\":\"Green Component|real|0.570823609828949"
    "Ansi 6 Color\":\"Red Component|real|0.1467953473329544"
    "Ansi 7 Color\":\"Blue Component|real|0.7978110313415527"
    "Ansi 7 Color\":\"Green Component|real|0.8900123834609985"
    "Ansi 7 Color\":\"Red Component|real|0.916110634803772"
    "Ansi 8 Color\":\"Blue Component|real|0.1517027318477631"
    "Ansi 8 Color\":\"Green Component|real|0.1178361028432846"
    "Ansi 8 Color\":\"Red Component|integer|0"
    "Ansi 9 Color\":\"Blue Component|real|0.07353043556213379"
    "Ansi 9 Color\":\"Green Component|real|0.2132530063390732"
    "Ansi 9 Color\":\"Red Component|real|0.7417625784873962"
    "BM Growl|integer|1"
    "Background Color\":\"Blue Component|real|0.1517027318477631"
    "Background Color\":\"Green Component|real|0.1178361028432846"
    "Background Color\":\"Red Component|integer|0"
    "Background Image Location|string|"
    "Badge Color\":\"Alpha Component|real|0.5"
    "Badge Color\":\"Blue Component|integer|0"
    "Badge Color\":\"Color Space|string|Calibrated"
    "Badge Color\":\"Green Component|integer|0"
    "Badge Color\":\"Red Component|integer|1"
    "Blinking Cursor|integer|0"
    "Blur|integer|1"
    "Blur Radius|real|5.61171875"
    "Bold Color\":\"Blue Component|real|0.5636365413665771"
    "Bold Color\":\"Green Component|real|0.5648583769798279"
    "Bold Color\":\"Red Component|real|0.5059919357299805"
    "Character Encoding|integer|4"
    "Close Sessions On End|integer|1"
    "Columns|integer|80"
    "Command|string|"
    "Cursor Color\":\"Blue Component|real|0.5168579816818237"
    "Cursor Color\":\"Green Component|real|0.5096293091773987"
    "Cursor Color\":\"Red Component|real|0.4405802488327026"
    "Cursor Guide Color\":\"Alpha Component|real|0.25"
    "Cursor Guide Color\":\"Blue Component|integer|1"
    "Cursor Guide Color\":\"Color Space|string|Calibrated"
    "Cursor Guide Color\":\"Green Component|real|0.91"
    "Cursor Guide Color\":\"Red Component|real|0.65"
    "Cursor Text Color\":\"Blue Component|real|0.1937013864517212"
    "Cursor Text Color\":\"Green Component|real|0.155759260058403"
    "Cursor Text Color\":\"Red Component|integer|0"
    "Custom Command|string|No"
    "Custom Directory|string|No"
    "Default Bookmark|string|No"
    "Description|string|Default"
    "Disable Window Resizing|integer|1"
    "Flashing Bell|integer|0"
    "Foreground Color\":\"Blue Component|real|0.5168579816818237"
    "Foreground Color\":\"Green Component|real|0.5096293091773987"
    "Foreground Color\":\"Red Component|real|0.4405802488327026"
    "Guid|string|D9CD6010-E58D-4FE0-8293-2B3D93E9332F"
    "Horizontal Spacing|integer|1"
    "Idle Code|integer|0"
    "Jobs to Ignore\":\"0|data|rlogin"
    "Jobs to Ignore\":\"1|data|ssh"
    "Jobs to Ignore\":\"2|data|slogin"
    "Jobs to Ignore\":\"3|data|telnet"
    "Keyboard Map\":\"0x2d-0x40000\":\"Action|integer|11"
    "Keyboard Map\":\"0x2d-0x40000\":\"Text|string|0x1f"
    "Keyboard Map\":\"0x32-0x40000\":\"Action|integer|11"
    "Keyboard Map\":\"0x32-0x40000\":\"Text|string|0x00"
    "Keyboard Map\":\"0x33-0x40000\":\"Action|integer|11"
    "Keyboard Map\":\"0x33-0x40000\":\"Text|string|0x1b"
    "Keyboard Map\":\"0x33-0x40000\":\"Action|integer|11"
    "Keyboard Map\":\"0x33-0x40000\":\"Text|string|0x1c"
    "Keyboard Map\":\"0x35-0x40000\":\"Action|integer|11"
    "Keyboard Map\":\"0x35-0x40000\":\"Text|string|0x1d"
    "Keyboard Map\":\"0x36-0x40000\":\"Action|integer|11"
    "Keyboard Map\":\"0x36-0x40000\":\"Text|string|0x1e"
    "Keyboard Map\":\"0x37-0x40000\":\"Action|integer|11"
    "Keyboard Map\":\"0x37-0x40000\":\"Text|string|0x1f"
    "Keyboard Map\":\"0x38-0x40000\":\"Action|integer|11"
    "Keyboard Map\":\"0x38-0x40000\":\"Text|string|0x7f"
    "Keyboard Map\":\"0xf700-0x220000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf700-0x220000\":\"Text|string|[12A"
    "Keyboard Map\":\"0xf700-0x240000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf700-0x240000\":\"Text|string|[15A"
    "Keyboard Map\":\"0xf700-0x260000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf700-0x260000\":\"Text|string|[16A"
    "Keyboard Map\":\"0xf700-0x280000\":\"Action|integer|11"
    "Keyboard Map\":\"0xf700-0x280000\":\"Text|string|0x1b 0x1b 0x5b 0x41"
    "Keyboard Map\":\"0xf701-0x220000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf701-0x220000\":\"Text|string|[12B"
    "Keyboard Map\":\"0xf701-0x240000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf701-0x240000\":\"Text|string|[15B"
    "Keyboard Map\":\"0xf701-0x260000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf701-0x260000\":\"Text|string|[16B"
    "Keyboard Map\":\"0xf701-0x280000\":\"Action|integer|11"
    "Keyboard Map\":\"0xf701-0x280000\":\"Text|string|0x1b 0x1b 0x5b 0x42"
    "Keyboard Map\":\"0xf702-0x220000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf702-0x220000\":\"Text|string|[12D"
    "Keyboard Map\":\"0xf702-0x240000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf702-0x240000\":\"Text|string|[15D"
    "Keyboard Map\":\"0xf702-0x260000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf702-0x260000\":\"Text|string|[16D"
    "Keyboard Map\":\"0xf702-0x280000\":\"Action|integer|11"
    "Keyboard Map\":\"0xf702-0x280000\":\"Text|string|0x1b 0x1b 0x5b 0x44"
    "Keyboard Map\":\"0xf703-0x220000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf703-0x220000\":\"Text|string|[12C"
    "Keyboard Map\":\"0xf703-0x240000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf703-0x240000\":\"Text|string|[15C"
    "Keyboard Map\":\"0xf703-0x260000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf703-0x260000\":\"Text|string|[16C"
    "Keyboard Map\":\"0xf703-0x280000\":\"Action|integer|11"
    "Keyboard Map\":\"0xf703-0x280000\":\"Text|string|0x1b 0x1b 0x5b 0x43"
    "Keyboard Map\":\"0xf704-0x20000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf704-0x20000\":\"Text|string|[12P"
    "Keyboard Map\":\"0xf705-0x20000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf705-0x20000\":\"Text|string|[12Q"
    "Keyboard Map\":\"0xf706-0x20000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf706-0x20000\":\"Text|string|[12R"
    "Keyboard Map\":\"0xf707-0x20000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf707-0x20000\":\"Text|string|[12S"
    "Keyboard Map\":\"0xf708-0x20000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf708-0x20000\":\"Text|string|[152~"
    "Keyboard Map\":\"0xf709-0x20000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf709-0x20000\":\"Text|string|[172~"
    "Keyboard Map\":\"0xf70a-0x20000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf70a-0x20000\":\"Text|string|[182~"
    "Keyboard Map\":\"0xf70b-0x20000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf70b-0x20000\":\"Text|string|[192~"
    "Keyboard Map\":\"0xf70c-0x20000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf70c-0x20000\":\"Text|string|[202~"
    "Keyboard Map\":\"0xf70d-0x20000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf70d-0x20000\":\"Text|string|[212~"
    "Keyboard Map\":\"0xf70e-0x20000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf70e-0x20000\":\"Text|string|[232~"
    "Keyboard Map\":\"0xf70f-0x20000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf70f-0x20000\":\"Text|string|[242~"
    "Keyboard Map\":\"0xf729-0x20000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf729-0x20000\":\"Text|string|[12H"
    "Keyboard Map\":\"0xf729-0x40000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf729-0x40000\":\"Text|string|[15H"
    "Keyboard Map\":\"0xf72b-0x20000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf72b-0x20000\":\"Text|string|[12F"
    "Keyboard Map\":\"0xf72b-0x40000\":\"Action|integer|10"
    "Keyboard Map\":\"0xf72b-0x40000\":\"Text|string|[15F"
    "Keyboard Map\":\"Link Color\":\"Alpha Component|integer|1"
    "Keyboard Map\":\"Link Color\":\"Blue Component|real|0.678"
    "Keyboard Map\":\"Link Color\":\"Color Space|string|Calibrated"
    "Keyboard Map\":\"Link Color\":\"Green Component|real|0.27"
    "Keyboard Map\":\"Link Color\":\"Red Component|real|0.023"
    "Mouse Reporting|integer|1"
    "Name|string|Default"
    "Non Ascii Font|string|Monaco 12"
    "Non-ASCII Anti Aliased|integer|1"
    "Normal Font|string|UbuntuMonoDerivativePowerline-Regular 16"
    "Only The Default BG Color Uses Transparency|string|0"
    "Option Key Sends|integer|0"
    "Prompt Before Closing 2|integer|0"
    "Right Option Key Sends|integer|0"
    "Rows|integer|25"
    "Screen|string|-1"
    "Scrollback Lines|integer|1000"
    "Selected Text Color\":\"Alpha Component|integer|1"
    "Selected Text Color\":\"Blue Component|real|0.7186503410339355"
    "Selected Text Color\":\"Color Space|string|Calibrated"
    "Selected Text Color\":\"Green Component|real|0.7200272083282471"
    "Selected Text Color\":\"Red Component|real|0.6539754867553711"
    "Selection Color\":\"Alpha Component|integer|1"
    "Selection Color\":\"Blue Component|real|0.09438608586788177"
    "Selection Color\":\"Color Space|string|Calibrated"
    "Selection Color\":\"Green Component|real|0.267566442489624"
    "Selection Color\":\"Red Component|real|0.08782456815242767"
    "Send Code When Idle|integer|0"
    "Shortcut|string|"
    "Silence Bell|integer|0"
    "Sync Title|integer|0"
    "Tags\":\"0|dict|"
    "Terminal Type|string|xterm-256color"
    "Transparency|real|0.0"
    "Unlimited Scrollback|integer|1"
    "Use Bold Font|integer|1"
    "Use Bright Bold|integer|1"
    "Use Italic Font|integer|1"
    "Use Non-ASCII Font|integer|0"
    "Vertical Spacing|integer|1"
    "Visual Bell|integer|1"
    "Window Type|integer|0"
    "Working Directory|string|${HOME}"
)

