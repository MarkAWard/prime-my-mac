#!/usr/bin/env bash

#
#  A P P S . S H
#


function activity_monitor_config {
    status_msg "0" "Custom Activity Monitor.app config"

    #  Show the main window when launching Activity Monitor
    defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

    #  Visualize CPU usage in the Activity Monitor Dock icon
    defaults write com.apple.ActivityMonitor IconType -int 5

    #  Show all processes in Activity Monitor
    defaults write com.apple.ActivityMonitor ShowCategory -int 0
}


# function google_chrome_config {
#     status_msg "0" "Custom Google Chrome.app config"

#     #  Copy master_preferences file for automated install on first use
#     #  - https://support.google.com/chrome/a/answer/187948
#     #  - https://support.google.com/chrome/a/answer/188453
#     cp -n ./files/chrome_master_preferences.json '/Applications/Google Chrome.app/Contents/MacOS/master_preferences'

#     local CHROME_PLIST="$HOME/Library/Preferences/com.google.Chrome.plist"
#     if [ -f $CHROME_PLIST ]; then

#         #  Allow installing user scripts via GitHub Gist or Userscripts.org
#         defaults write com.google.Chrome ExtensionInstallSources -array "https://gist.githubusercontent.com/" "http://userscripts.org/*"

#         #  Disable the all too sensitive backswipe on trackpads
#         defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

#         #  Disable the all too sensitive backswipe on Magic Mouse
#         defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false

#         #  Use the system-native print preview dialog
#         defaults write com.google.Chrome DisablePrintPreview -bool true

#         #  Expand the print dialog by default
#         defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
#     fi
# }


function terminal_config {
    status_msg "0" "Custom Terminal.app config"

    #  Only use UTF-8 in Terminal.app
    #  For Terminal theme, see: https://github.com/geerlingguy/mac-dev-playbook
    defaults write com.apple.terminal StringEncodings -array 4
}


function vscode_config {
    status_msg "0" "Custom VSCode.app config"

    #  Install extensions
    for extension in "${vscode_extensions[@]}"; do
        code --install-extension ${extension} --force
    done

    #  Copy + symlink config file
    cp -n ./files/settings.json "${HOME}/Library/Application Support/Code/User/settings.json"
    mkdir -p "${HOME}/.vscode"
    ln -sf "${HOME}/Library/Application\ Support/Code/User/settings.json" "${HOME}/.vscode/settings.json"
}
