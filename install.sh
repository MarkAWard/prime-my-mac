#!/usr/bin/env bash

#
#  I N S T A L L . S H
#
#  Dispatches individual install_* / *_tweaks / *_config functions based
#  on flags. Each flag corresponds to a chunk of the bootstrap:
#
#    --python     pyenv + python versions + pip packages
#    --node       nvm + Node LTS
#    --brew       Homebrew formulae (libs/data.sh brew_pkgs)
#    --cask       Homebrew casks (libs/data.sh cask_pkgs)
#    --fonts      Homebrew cask fonts (libs/data.sh cask_fonts)
#    --github     `gh auth login` + git credential helper
#    --osx        defaults-write tweaks for dock/finder/etc.
#    --app-configs  per-app configs (vscode/iterm2/etc.)
#    --prezto     install prezto (zsh framework)
#    --bash-it    install bash-it (bash framework)
#    --dot-files  stage dotfiles at ~/.dotfiles and ~/.config/git/
#    --all        run everything above in a sensible order
#


#  Include libraries
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
for INCLUDE in $DIR/libs/*; do
    source ${INCLUDE}
done

#  Usage
usage() {
    echo -e "${BOLD}Usage${NORMAL}: ${0##*/} [ ${BOLD}--all${NORMAL} | ${BOLD}--app-configs${NORMAL} | ${BOLD}--bash-it${NORMAL} | ${BOLD}--brew${NORMAL} | ${BOLD}--cask${NORMAL} | ${BOLD}--dot-files${NORMAL} | ${BOLD}--fonts${NORMAL} | ${BOLD}--github${NORMAL} | ${BOLD}--node${NORMAL} | ${BOLD}--python${NORMAL} | ${BOLD}--prezto${NORMAL} | ${BOLD}--osx${NORMAL} ]" 1>&2
    exit 1
}

# Installation flags
FG_ALL=false
FG_APPS=false
FG_BASH_IT=false
FG_BREW=false
FG_BREW_CASK=false
FG_DOTFILES=false
FG_BREW_FONTS=false
FG_GITHUB=false
FG_NODE=false
FG_OSX=false
FG_PYTHON=false
FG_PREZTO=false

#  Determine flags enabled via parameters. `[ -z "$@" ]` expands to multiple
#  args when more than one flag is passed and errors with "too many arguments",
#  so check the positional count directly.
if [ "$#" -eq 0 ]; then
    usage
else
    for arg in "$@"; do
        shift
        case "$arg" in
            --all)         FG_ALL=true ;;               #  EVERYTHING!
            --app-configs) FG_APPS=true ;;              #  Apps
            --bash-it)     FG_BASH_IT=true ;;           #  bash it
            --brew)        FG_BREW=true ;;              #  Brew
            --cask)        FG_BREW_CASK=true ;;         #  Brew Cask
            --dot-files)   FG_DOTFILES=true ;;          #  Dot files
            --fonts)       FG_BREW_FONTS=true ;;        #  Brew Fonts
            --github)      FG_GITHUB=true ;;            #  GitHub CLI auth
            --node)        FG_NODE=true ;;              #  nvm + Node LTS
            --osx)         FG_OSX=true ;;               #  OS X
            --python)      FG_PYTHON=true ;;            #  python
            --prezto)      FG_PREZTO=true ;;            #  prezto
            *)             usage ;;
        esac
    done
fi

#  Invoke sudo and update sudo timestamp until script is finished
sudo -v
while true; do
    sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

#  Install components — brew first so language toolchains below have their
#  build deps (pyenv needs openssl/readline/sqlite/xz/zlib from brew_pkgs).
[[ "$FG_ALL" == true || "$FG_BREW" == true ]]       && install_brew
[[ "$FG_ALL" == true || "$FG_BREW_CASK" == true ]]  && install_brew_cask
[[ "$FG_ALL" == true || "$FG_BREW_FONTS" == true ]] && install_brew_fonts
[[ "$FG_ALL" == true || "$FG_GITHUB" == true ]]     && install_github_auth
[[ "$FG_ALL" == true || "$FG_PYTHON" == true ]]     && install_python
[[ "$FG_ALL" == true || "$FG_NODE" == true ]]       && install_node

#  OS X Customizations
if [[ "$FG_ALL" == true || "$FG_OSX" == true ]]; then
    dock_tweaks
    finder_tweaks
    input_device_tweaks
    screen_tweaks
    spotlight_tweaks
    energy_tweaks
    miscellaneous_tweaks
    security_tweaks
    touchid_sudo_tweaks
    app_store_tweaks
fi

#  App specific Customizations
if [[ "$FG_ALL" == true || "$FG_APPS" == true ]]; then
    activity_monitor_config
    terminal_config
    vscode_config
    iterm2_config
fi

#  Set user shell last
[[ "$FG_ALL" == true || "$FG_BASH_IT"  == true ]] && install_bash_it
[[ "$FG_ALL" == true || "$FG_PREZTO"   == true ]] && install_prezto
[[ "$FG_ALL" == true || "$FG_DOTFILES" == true ]] && install_dotfiles

#  Done!
status_msg "ALERT" "Install Complete"
exit 0
