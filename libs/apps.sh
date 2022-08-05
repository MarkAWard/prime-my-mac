#!/usr/bin/env bash

#
#  A P P S . S H
#

function activity_monitor_config {
    status_msg "Custom Activity Monitor.app config"

    #  Show the main window when launching Activity Monitor
    defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

    #  Visualize CPU usage in the Activity Monitor Dock icon
    defaults write com.apple.ActivityMonitor IconType -int 5

    #  Show all processes in Activity Monitor
    defaults write com.apple.ActivityMonitor ShowCategory -int 0

    # Sort Activity Monitor results by CPU usage
    defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
    defaults write com.apple.ActivityMonitor SortDirection -int 0

    killall "Activity Monitor"

    status_msg "0" "Custom Activity Monitor.app config"
}


function google_chrome_config {
    status_msg "Custom Google Chrome.app config"

    #  Copy master_preferences file for automated install on first use
    #  - https://support.google.com/chrome/a/answer/187948
    #  - https://support.google.com/chrome/a/answer/188453
    cp -n ./files/chrome_master_preferences.json '/Applications/Google Chrome.app/Contents/MacOS/master_preferences'

    local CHROME_PLIST="$HOME/Library/Preferences/com.google.Chrome.plist"
    if [ -f $CHROME_PLIST ]; then

        #  Allow installing user scripts via GitHub Gist or Userscripts.org
        defaults write com.google.Chrome ExtensionInstallSources -array "https://gist.githubusercontent.com/" "http://userscripts.org/*"

        #  Disable the all too sensitive backswipe on trackpads
        # defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

        #  Disable the all too sensitive backswipe on Magic Mouse
        # defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false

        #  Use the system-native print preview dialog
        defaults write com.google.Chrome DisablePrintPreview -bool true

        #  Expand the print dialog by default
        defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
    fi
    status_msg "0" "Custom Google Chrome.app config"
}


function terminal_config {
    status_msg "Custom Terminal.app config"

    #  Only use UTF-8 in Terminal.app
    #  For Terminal theme, see: https://github.com/geerlingguy/mac-dev-playbook
    defaults write com.apple.terminal StringEncodings -array 4

    status_msg "0" "Custom Terminal.app config"
}

function iterm2_config {
#
#  See:
#  - http://www.starkandwayne.com/blog/tweaking-iterm2-and-playing-with-plists/
#  - https://github.com/fnichol/macosx-iterm2-settings
#  - http://www.real-world-systems.com/docs/PlistBuddy.1.html
#  - https://iterm2.com/documentation-hidden-settings.html
#
    status_msg "Custom iTerm2.app config"

    local ITERM2_PLIST="${HOME}/Library/Preferences/com.googlecode.iterm2.plist"
    if [ -f ${ITERM2_PLIST} ]; then

        #  Set custom settings
        defaults write com.googlecode.iterm2 CursorType -bool false
        defaults write com.googlecode.iterm2 DimInactiveSplitPanes -bool true
        defaults write com.googlecode.iterm2 HideTab -bool false
        defaults write com.googlecode.iterm2 HighlightTabLabels -bool true
        defaults write com.googlecode.iterm2 NoSyncDoNotWarnBeforeMultilinePaste -bool true
        defaults write com.googlecode.iterm2 NoSyncDoNotWarnBeforeMultilinePaste_selection -bool false
        defaults write com.googlecode.iterm2 NoSyncNeverAskAboutSettingAlternateMouseScroll -bool true
        defaults write com.googlecode.iterm2 NoSyncPermissionToShowTip -bool false
        defaults write com.googlecode.iterm2 OnlyWhenMoreTabs -bool true
        defaults write com.googlecode.iterm2 PromptOnQuit -bool false
        defaults write com.googlecode.iterm2 QuitWhenAllWindowsClosed -bool true
        defaults write com.googlecode.iterm2 SUEnableAutomaticChecks -bool true
        defaults write com.googlecode.iterm2 SUSendProfileInfo -bool false
        defaults write com.googlecode.iterm2 UseBorder -bool true
        defaults write com.googlecode.iterm2 WindowNumber -bool true;

        #  Set custom bookmarks settings
        for bookmark in "${iterm_bookmark_settings[@]}"; do
            key_name=$( echo "${bookmark}" | cut -d'|' -f1)
            key_type=$( echo "${bookmark}" | cut -d'|' -f2)
            key_value=$(echo "${bookmark}" | cut -d'|' -f3)

            #  Update Bookmark key
            local SET_BOOKMARK=$(/usr/libexec/PlistBuddy -c "Set :\"New Bookmarks\":0:\"${key_name}\" \"${key_value}\"" ${ITERM2_PLIST} > /dev/null 2>&1; echo $?)
            [ ! ${SET_BOOKMARK} ] && /usr/libexec/PlistBuddy -c "Add :\"New Bookmarks\":0:\"${key_value}\" ${key_type} \"${key_value}\"" ${ITERM2_PLIST}
        done
    fi

    status_msg "0" "Custom iTerm2.app config"
}


function vscode_config {
    status_msg "Custom VSCode.app config"

    #  Install extensions
    for extension in "${vscode_extensions[@]}"; do
        code --install-extension ${extension} --force
    done

    #  Copy + symlink config file
    cp -n ./files/vscode_settings.json "${HOME}/Library/Application Support/Code/User/settings.json"
    mkdir -p "${HOME}/.vscode"
    ln -sf "${HOME}/Library/Application\ Support/Code/User/settings.json" "${HOME}/.vscode/settings.json"

    status_msg "0" "Custom VSCode.app config"
}

function itunes_config {
    status_msg "Custom iTunes.app config"

    #  Stop iTunes from responding to the keyboard media keys
    launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

    status_msg "0" "Custom iTunes.app config"
}

function mail_config {
    status_msg "Custom Mail.app config"

    #  Disable send and reply animations in Mail.app
    defaults write com.apple.mail DisableReplyAnimations -bool true
    defaults write com.apple.mail DisableSendAnimations -bool true

    #  Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
    defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

    #  Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
    # defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" -string "@\\U21a9"

    #  Display emails in threaded mode
    defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
    # defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
    # defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

    #  Disable inline attachments (just show the icons)
    defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

    #  Disable spell checking
    # defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

    status_msg "0" "Custom Mail.app config"
}

function safari_config {
    status_msg "Custom Safari.app config"

    #  Set Safari’s home page to `about:blank` for faster loading
    defaults write com.apple.Safari HomePage -string "about:blank"

    #  Prevent Safari from opening ‘safe’ files automatically after downloading
    defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

    #  Show status bar at bottom to view URLs links on hover
    defaults write com.apple.Safari 'ShowStatusBar' -bool true

    #  Disable Safari’s thumbnail cache for History and Top Sites
    defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

    #  Enable Safari’s debug menu
    defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

    #  Enable the Develop menu and the Web Inspector in Safari
    defaults write com.apple.Safari IncludeDevelopMenu -bool true
    defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
    defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

    #  Add a context menu item for showing the Web Inspector in web views
    defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

    status_msg "0" "Custom Safari.app config"
}
