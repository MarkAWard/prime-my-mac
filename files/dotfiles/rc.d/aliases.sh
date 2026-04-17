#  Trick to make aliases available when using sudo
alias sudo='sudo '

# alias for nice ps output (macos/linux versions)
if [[ "$(uname)" == "Darwin" ]]; then
    alias psc='ps xao pid,state,user,args'
elif [[ "$(uname)" == "Linux" ]]; then
    alias psc='ps xawfo pid,state,user,args'
fi

# sum (e.g. echo 1 2 3 |sum)
alias sum="xargs | tr ' ' '+' | bc"

#  Prezto's `git` module aliases `grc` to `git rebase --continue`, which
#  shadows the `grc` (Generic Colouriser) binary that `rc.d/grc.sh` relies
#  on — `which grc` would return the alias, not the binary path.
#  Guard: only unalias if prezto actually defined it.
alias grc &>/dev/null && unalias grc

#  coreutils `ls` is on PATH via .zprofile — load dircolors and turn on color
eval `dircolors ${HOME}/.dircolors`
alias ls='ls --color=auto'

#  Aliases -- https://natelandau.com/my-mac-osx-bash_profile/
alias cp='cp -iv'                                   # Preferred 'cp' implementation
alias mv='mv -iv'                                   # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                             # Preferred 'mkdir' implementation
alias ll='ls -FlAhp'                                # Preferred 'ls' implementation
alias diff='colordiff -W $(( $(tput cols) - 2 ))'   # Colorized diff at full terminal width
alias xx='eza --long --all --header --git --icons --group-directories-first'  # Fancy eza view (needs a Nerd Font)
alias cd..='cd ../'                                 # Go back 1 directory level (for fast typers)
alias ..='cd ../'                                   # Go back 1 directory level
alias ...='cd ../../'                               # Go back 2 directory levels
alias .2='cd ../../'                                # Go back 2 directory levels
alias .3='cd ../../../'                             # Go back 3 directory levels
alias .4='cd ../../../../'                          # Go back 4 directory levels
alias .5='cd ../../../../../'                       # Go back 5 directory levels
alias .6='cd ../../../../../../'                    # Go back 6 directory levels
alias f='open -a Finder ./'                         # f:            Opens current directory in MacOS Finder
alias c='clear'                                     # c:            Clear terminal display
alias path='echo -e ${PATH//:/\\n}'                 # path:         Echo all executable Paths
alias fix_stty='stty sane'                          # fix_stty:     Restore terminal settings when screwed up

#  colorize!
alias pgcli="PAGER='grcat ~/.grcat | less -iMSx4FXRe' pgcli"

alias myip="curl ipinfo.io/ip; echo"

# New ones!
alias tf='terraform'
alias tg='terragrunt'
alias k='kubectl'
alias kx='kubectx'
alias kns='kubens'
alias dc='docker compose'
alias reload='exec zsh -l'                          # reload shell config without opening a new terminal
