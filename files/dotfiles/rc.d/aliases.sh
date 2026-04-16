#  Trick to make aliases available when using sudo
alias sudo='sudo '

#  Display all history
alias history="cat $HISTFILE"

#  Use colordiff if available
if which colordiff &> /dev/null; then
    alias diff='colordiff'
fi

# alias for nice ps output (macos/linux versions)
if [[ "$(uname)" == "Darwin" ]]; then
    alias psc='ps xao pid,state,user,args'
elif [[ "$(uname)" == "Linux" ]]; then
    alias psc='ps xawfo pid,state,user,args'
fi

# sum (e.g. echo 1 2 3 |sum)
alias sum="xargs | tr ' ' '+' | bc"

#  Unalias some git module cmds (if they exist as aliases)
alias gs  &>/dev/null && unalias gs
alias gls &>/dev/null && unalias gls
alias gpt &>/dev/null && unalias gpt
alias grc &>/dev/null && unalias grc

#  Use gnu ls + dircolors
eval `gdircolors ${HOME}/.dircolors`
alias ls='gls --color=auto'

#  Aliases -- https://natelandau.com/my-mac-osx-bash_profile/
alias cp='cp -iv'                                   # Preferred 'cp' implementation
alias mv='mv -iv'                                   # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                             # Preferred 'mkdir' implementation
alias ll='ls -FGlAhp'                               # Preferred 'ls' implementation
alias diff='diff -W $(( $(tput cols) - 2 ))'        # Preferred 'diff' use full width
alias xx='eza --long -a --header'                   # My eza view
alias less='less -FSRXc'                            # Preferred 'less' implementation
alias cd..='cd ../'                                 # Go back 1 directory level (for fast typers)
alias ..='cd ../'                                   # Go back 1 directory level
alias ...='cd ../../'                               # Go back 2 directory levels
alias .2='cd ../../'                                # Go back 2 directory levels
alias .3='cd ../../../'                             # Go back 3 directory levels
alias .4='cd ../../../../'                          # Go back 4 directory levels
alias .5='cd ../../../../../'                       # Go back 5 directory levels
alias .6='cd ../../../../../../'                    # Go back 6 directory levels
alias edit='code'                                   # edit:         Opens any file in VS Code
alias f='open -a Finder ./'                         # f:            Opens current directory in MacOS Finder
alias ~="cd ~"                                      # ~:            Go Home
alias c='clear'                                     # c:            Clear terminal display
alias path='echo -e ${PATH//:/\\n}'                 # path:         Echo all executable Paths
alias show_options='shopt'                          # Show_options: display bash options settings
alias fix_stty='stty sane'                          # fix_stty:     Restore terminal settings when screwed up
alias cic='set completion-ignore-case On'           # cic:          Make tab-completion case-insensitive
alias DT='tee ~/Desktop/terminalOut.txt'            # DT:           Pipe content to file on MacOS Desktop

#  colorize!
alias pgcli="PAGER='grcat ~/.grcat | less -iMSx4FXRe' pgcli"

alias myip="curl ipinfo.io/ip; echo"

# New ones!
alias tf='terraform'
alias k='kubectl'
