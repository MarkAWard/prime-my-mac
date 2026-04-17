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
    cursor
    dbeaver-community
    docker
    google-chrome
    iterm2
    postman
    rectangle
    spotify
    visual-studio-code
)


#  Nerd Fonts — includes powerline glyphs (for agnoster prompt) + icon
#  sets for modern tools (eza --icons, lazygit, k9s, starship).
#  Install a handful of popular options for easy switching.
declare cask_fonts=(
    jetbrains-mono-nerd-font          #  Default; great readability
    fira-code-nerd-font               #  Programming ligatures
    meslo-lg-nerd-font                #  Classic — recommended by powerlevel10k
    hack-nerd-font                    #  Clean, widely used
    ubuntu-mono-nerd-font             #  Continuity with prior setup
)


#  Dock Apps
declare dock_apps=(
    'Launchpad:sys'
    '--'
    'Google Chrome'
    'Cursor'
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
)


#  VS Code extensions
#  Installed into both VS Code and Cursor.
#  Note: gitlens is listed twice on purpose — `eamodio.gitlens` exists only on
#  the VS Code marketplace (Cursor blocks it), while `KylinIdeTeam.gitlens` is
#  the OpenVSX fork used by Cursor (404 on the VS Code marketplace). Each CLI
#  silently skips the one it can't resolve, so both editors end up with gitlens.
declare vscode_extensions=(
    'aaron-bond.better-comments'          # Highlight TODO/FIXME/etc. comment styles
    'charliermarsh.ruff'                  # Ruff formatter + linter (used by [python] config)
    'christian-kohler.path-intellisense'  # Autocomplete filesystem paths
    'eamodio.gitlens'                     # Git blame/history inline (VS Code only)
    'KylinIdeTeam.gitlens'                # GitLens fork on OpenVSX (Cursor only)
    'fabiospampinato.vscode-diff'         # Diff arbitrary files
    'hashicorp.terraform'                 # Terraform/HCL language server
    'ms-azuretools.vscode-docker'         # Docker UI and linting
    'ms-python.debugpy'                   # Python debugger (required by ms-python.python)
    'ms-python.python'                    # Python language support
    'ms-toolsai.jupyter'                  # Jupyter notebooks (+ keymap/renderers deps)
    'ms-vscode-remote.remote-containers'  # Dev containers
    'mtxr.sqltools'                       # SQL client + formatter
    'redhat.vscode-yaml'                  # YAML schema + formatter
    'ryu1kn.partial-diff'                 # Diff two selections
    'ryu1kn.text-marker'                  # Persistent text highlights
    'tamasfe.even-better-toml'            # TOML syntax (pyproject.toml, etc.)
    'tyriar.sort-lines'                   # Sort selected lines
    'vscode-icons-team.vscode-icons'      # File/folder icons (matches workbench.iconTheme)
    'wayou.vscode-todo-highlight'         # Highlight TODO/FIXME keywords
    'wmaurer.change-case'                 # camelCase/snake_case/etc. conversions
    'wmiller4.python-venv-switcher'       # Quick pyenv/venv switcher
    'yzhang.markdown-all-in-one'          # Markdown editing: TOC, shortcuts, preview
)


#  iTerm2 default profile ("New Bookmarks"[0]) — intentional overrides only.
#
#  Format: "PlistBuddy-path|type|value". Nested paths use \":\" as separator.
#  Values that match iTerm2 defaults are omitted — this array should document
#  only what actually differs from a stock profile. Color values are the
#  Solarized Dark palette.
declare iterm_bookmark_settings=(
    #  --- Identity ---
    "Guid|string|D9CD6010-E58D-4FE0-8293-2B3D93E9332F"
    "Name|string|Default"

    #  --- Font ---
    "Normal Font|string|JetBrainsMonoNFM-Regular 16"

    #  --- ANSI color palette (Solarized Dark: base03 → base3, red → violet) ---
    "Ansi 0 Color\":\"Red Component|real|0"
    "Ansi 0 Color\":\"Green Component|real|0.155759"
    "Ansi 0 Color\":\"Blue Component|real|0.193701"
    "Ansi 1 Color\":\"Red Component|real|0.819270"
    "Ansi 1 Color\":\"Green Component|real|0.108407"
    "Ansi 1 Color\":\"Blue Component|real|0.141457"
    "Ansi 2 Color\":\"Red Component|real|0.449775"
    "Ansi 2 Color\":\"Green Component|real|0.541155"
    "Ansi 2 Color\":\"Blue Component|real|0.020209"
    "Ansi 3 Color\":\"Red Component|real|0.647465"
    "Ansi 3 Color\":\"Green Component|real|0.467514"
    "Ansi 3 Color\":\"Blue Component|real|0.023485"
    "Ansi 4 Color\":\"Red Component|real|0.127549"
    "Ansi 4 Color\":\"Green Component|real|0.462659"
    "Ansi 4 Color\":\"Blue Component|real|0.782314"
    "Ansi 5 Color\":\"Red Component|real|0.777389"
    "Ansi 5 Color\":\"Green Component|real|0.108025"
    "Ansi 5 Color\":\"Blue Component|real|0.435166"
    "Ansi 6 Color\":\"Red Component|real|0.146795"
    "Ansi 6 Color\":\"Green Component|real|0.570824"
    "Ansi 6 Color\":\"Blue Component|real|0.525023"
    "Ansi 7 Color\":\"Red Component|real|0.916111"
    "Ansi 7 Color\":\"Green Component|real|0.890012"
    "Ansi 7 Color\":\"Blue Component|real|0.797811"
    "Ansi 8 Color\":\"Red Component|real|0"
    "Ansi 8 Color\":\"Green Component|real|0.117836"
    "Ansi 8 Color\":\"Blue Component|real|0.151703"
    "Ansi 9 Color\":\"Red Component|real|0.741763"
    "Ansi 9 Color\":\"Green Component|real|0.213253"
    "Ansi 9 Color\":\"Blue Component|real|0.073530"
    "Ansi 10 Color\":\"Red Component|real|0.276720"
    "Ansi 10 Color\":\"Green Component|real|0.356660"
    "Ansi 10 Color\":\"Blue Component|real|0.382985"
    "Ansi 11 Color\":\"Red Component|real|0.324366"
    "Ansi 11 Color\":\"Green Component|real|0.407177"
    "Ansi 11 Color\":\"Blue Component|real|0.438506"
    "Ansi 12 Color\":\"Red Component|real|0.440580"
    "Ansi 12 Color\":\"Green Component|real|0.509629"
    "Ansi 12 Color\":\"Blue Component|real|0.516858"
    "Ansi 13 Color\":\"Red Component|real|0.347986"
    "Ansi 13 Color\":\"Green Component|real|0.338963"
    "Ansi 13 Color\":\"Blue Component|real|0.729084"
    "Ansi 14 Color\":\"Red Component|real|0.505992"
    "Ansi 14 Color\":\"Green Component|real|0.564858"
    "Ansi 14 Color\":\"Blue Component|real|0.563637"
    "Ansi 15 Color\":\"Red Component|real|0.989434"
    "Ansi 15 Color\":\"Green Component|real|0.957944"
    "Ansi 15 Color\":\"Blue Component|real|0.864060"

    #  --- UI colors (pulled from the palette above) ---
    "Foreground Color\":\"Red Component|real|0.440580"
    "Foreground Color\":\"Green Component|real|0.509629"
    "Foreground Color\":\"Blue Component|real|0.516858"
    "Background Color\":\"Red Component|real|0"
    "Background Color\":\"Green Component|real|0.117836"
    "Background Color\":\"Blue Component|real|0.151703"
    "Cursor Color\":\"Red Component|real|0.440580"
    "Cursor Color\":\"Green Component|real|0.509629"
    "Cursor Color\":\"Blue Component|real|0.516858"
    "Cursor Text Color\":\"Red Component|real|0"
    "Cursor Text Color\":\"Green Component|real|0.155759"
    "Cursor Text Color\":\"Blue Component|real|0.193701"
    "Selection Color\":\"Red Component|real|0.087825"
    "Selection Color\":\"Green Component|real|0.267566"
    "Selection Color\":\"Blue Component|real|0.094386"
    "Selected Text Color\":\"Red Component|real|0.653975"
    "Selected Text Color\":\"Green Component|real|0.720027"
    "Selected Text Color\":\"Blue Component|real|0.718650"

    #  --- Behavior overrides (everything else uses iTerm2 defaults) ---
    "Terminal Type|string|xterm-256color"       # $TERM (default: xterm)
    "Unlimited Scrollback|integer|1"            # No scrollback cap
    "Visual Bell|integer|1"                     # Flash instead of beep
    "Blur|integer|1"                            # Blur behind transparent window
    "Blur Radius|real|5.61171875"
    "Disable Window Resizing|integer|1"         # Don't let apps resize the window

    #  --- Keyboard: Option+<n> → control codes for word/region nav ---
    #  Action 11 = Send Hex Code; Text is the hex bytes to send.
    "Keyboard Map\":\"0x2d-0x40000\":\"Action|integer|11"     # Opt+-
    "Keyboard Map\":\"0x2d-0x40000\":\"Text|string|0x1f"
    "Keyboard Map\":\"0x32-0x40000\":\"Action|integer|11"     # Opt+2
    "Keyboard Map\":\"0x32-0x40000\":\"Text|string|0x00"
    "Keyboard Map\":\"0x33-0x40000\":\"Action|integer|11"     # Opt+3
    "Keyboard Map\":\"0x33-0x40000\":\"Text|string|0x1c"
    "Keyboard Map\":\"0x35-0x40000\":\"Action|integer|11"     # Opt+5
    "Keyboard Map\":\"0x35-0x40000\":\"Text|string|0x1d"
    "Keyboard Map\":\"0x36-0x40000\":\"Action|integer|11"     # Opt+6
    "Keyboard Map\":\"0x36-0x40000\":\"Text|string|0x1e"
    "Keyboard Map\":\"0x37-0x40000\":\"Action|integer|11"     # Opt+7
    "Keyboard Map\":\"0x37-0x40000\":\"Text|string|0x1f"
    "Keyboard Map\":\"0x38-0x40000\":\"Action|integer|11"     # Opt+8
    "Keyboard Map\":\"0x38-0x40000\":\"Text|string|0x7f"

    #  --- Keyboard: Shift+Opt+Arrow → ESC ESC [ <dir> (tmux/vim meta-arrow) ---
    "Keyboard Map\":\"0xf700-0x280000\":\"Action|integer|11"  # Shift+Opt+Up
    "Keyboard Map\":\"0xf700-0x280000\":\"Text|string|0x1b 0x1b 0x5b 0x41"
    "Keyboard Map\":\"0xf701-0x280000\":\"Action|integer|11"  # Shift+Opt+Down
    "Keyboard Map\":\"0xf701-0x280000\":\"Text|string|0x1b 0x1b 0x5b 0x42"
    "Keyboard Map\":\"0xf702-0x280000\":\"Action|integer|11"  # Shift+Opt+Left
    "Keyboard Map\":\"0xf702-0x280000\":\"Text|string|0x1b 0x1b 0x5b 0x44"
    "Keyboard Map\":\"0xf703-0x280000\":\"Action|integer|11"  # Shift+Opt+Right
    "Keyboard Map\":\"0xf703-0x280000\":\"Text|string|0x1b 0x1b 0x5b 0x43"
)

