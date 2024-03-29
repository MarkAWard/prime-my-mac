#!/usr/bin/env bash

#
#  I N S T A L L . S H
#
#  Install OSX tools + customizations:
#  - pip
#  - homebrew + cask + fonts
#  - prezto + bash-it
#


#  Include libraries
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
for INCLUDE in $DIR/libs/*; do
    source ${INCLUDE}
done

#  Usage
usage() {
    echo -e "${BOLD}Usage${NORMAL}: ${0##*/} [ ${BOLD}--all${NORMAL} | ${BOLD}--app-configs${NORMAL} | ${BOLD}--bash-it${NORMAL} | ${BOLD}--brew${NORMAL} | ${BOLD}--cask${NORMAL} | ${BOLD}--dot-files${NORMAL} | ${BOLD}--fonts${NORMAL} | ${BOLD}--python${NORMAL} | ${BOLD}--prezto${NORMAL} | ${BOLD}--osx${NORMAL} ]" 1>&2
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
FG_OSX=false
FG_PYTHON=false
FG_PREZTO=false

#  Determine flags enabled via parameters
if [ -z "$@" ]; then
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

#  Enable "All Apps" install
security_allow_run_all_apps true

#  Install components
[[ "$FG_ALL" == true || "$FG_PYTHON" == true ]]     && install_python
[[ "$FG_ALL" == true || "$FG_BREW" == true ]]       && install_brew
[[ "$FG_ALL" == true || "$FG_BREW_CASK" == true ]]  && install_brew_cask
[[ "$FG_ALL" == true || "$FG_BREW_FONTS" == true ]] && install_brew_fonts

#  OS X Customizations
if [[ "$FG_ALL" == true || "$FG_OSX" == true ]]; then
    dock_tweaks
    finder_tweaks
    input_device_tweaks
    screen_tweaks
    spotlight_tweaks
    ssd_tweaks
    energy_tweaks
    miscellaneous_tweaks
    security_tweaks
    app_store_tweaks
fi

#  App specific Customizations
if [[ "$FG_ALL" == true || "$FG_APPS" == true ]]; then
    activity_monitor_config
    google_chrome_config
    terminal_config
    vscode_config
    iterm2_config
    itunes_config
    mail_config
    safari_config
fi

#  Set user shell last
[[ "$FG_ALL" == true || "$FG_BASH_IT"  == true ]] && install_bash_it
[[ "$FG_ALL" == true || "$FG_PREZTO"   == true ]] && install_prezto
[[ "$FG_ALL" == true || "$FG_DOTFILES" == true ]] && install_dotfiles

#  Done!
status_msg "ALERT" "Install Complete"
exit 0
