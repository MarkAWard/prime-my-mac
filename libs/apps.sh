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

    #  `killall` fails loudly on a fresh install where Activity Monitor hasn't
    #  been launched yet. Swallow the "No matching processes" noise.
    killall "Activity Monitor" 2>/dev/null || true

    status_msg "0" "Custom Activity Monitor.app config"
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

    #  On a fresh install iTerm2 hasn't been launched yet, so no plist exists
    #  and all of our defaults-write / PlistBuddy calls below would be no-ops.
    #  Launch it briefly to seed the file, then quit.
    if [ ! -f "${ITERM2_PLIST}" ] && [ -d "/Applications/iTerm.app" ]; then
        open -ga iTerm
        sleep 3
        osascript -e 'tell application "iTerm" to quit' >/dev/null 2>&1
        sleep 1
    fi

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

        #  Apply bookmark settings to the default profile (New Bookmarks[0]).
        #  PlistBuddy's Set fails if the key doesn't exist yet, so fall back
        #  to Add. (Note: prior versions of this loop passed the value in
        #  place of the key path on the Add branch, so missing keys were
        #  never actually added.)
        for bookmark in "${iterm_bookmark_settings[@]}"; do
            key_name=$( echo "${bookmark}" | cut -d'|' -f1)
            key_type=$( echo "${bookmark}" | cut -d'|' -f2)
            key_value=$(echo "${bookmark}" | cut -d'|' -f3)

            if ! /usr/libexec/PlistBuddy -c "Set :\"New Bookmarks\":0:\"${key_name}\" \"${key_value}\"" "${ITERM2_PLIST}" >/dev/null 2>&1; then
                /usr/libexec/PlistBuddy -c "Add :\"New Bookmarks\":0:\"${key_name}\" ${key_type} \"${key_value}\"" "${ITERM2_PLIST}" >/dev/null 2>&1
            fi
        done

        #  Force cfprefsd to drop its cache so the next `defaults read` sees
        #  our changes. iTerm2 still needs to be quit and relaunched — it
        #  holds prefs in memory and rewrites the plist on quit, which would
        #  otherwise clobber what we just wrote.
        killall cfprefsd 2>/dev/null
    fi

    status_msg "0" "Custom iTerm2.app config"
}


function vscode_config {
    status_msg "Custom VSCode.app config"

    #  Install extensions into both VS Code and Cursor (each ships its own CLI).
    #  Attribute tags on entries in vscode_extensions:
    #    :v  VS Code only (skip Cursor — usually not on OpenVSX)
    #    :c  Cursor only  (skip VS Code — usually not on the MS marketplace)
    #
    #  Cursor's bundled Node sometimes can't validate the marketplace's cert
    #  chain ("unable to get local issuer certificate") for a handful of
    #  extensions. Point it at the homebrew ca-certificates bundle when
    #  available — VS Code doesn't need this.
    local cert_bundle
    cert_bundle="$(brew --prefix 2>/dev/null)/etc/ca-certificates/cert.pem"

    for cli in code cursor; do
        command -v "${cli}" >/dev/null 2>&1 || continue

        for entry in "${vscode_extensions[@]}"; do
            local ext="${entry%%:*}"
            local attrs=""
            [[ "${entry}" == *:* ]] && attrs="${entry#*:}"

            [[ "${attrs}" == *v* && "${cli}" != "code"   ]] && continue
            [[ "${attrs}" == *c* && "${cli}" != "cursor" ]] && continue

            if [[ "${cli}" == "cursor" && -f "${cert_bundle}" ]]; then
                NODE_EXTRA_CA_CERTS="${cert_bundle}" "${cli}" --install-extension "${ext}" --force
            else
                "${cli}" --install-extension "${ext}" --force
            fi
        done
    done

    #  Deploy the same settings file to both VS Code and Cursor
    for app in "Code" "Cursor"; do
        local dest="${HOME}/Library/Application Support/${app}/User/settings.json"
        [ -d "$(dirname "${dest}")" ] && cp ./files/vscode_settings.json "${dest}"
    done

    status_msg "0" "Custom VSCode.app config"
}

