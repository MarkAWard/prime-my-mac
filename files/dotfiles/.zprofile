#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# Browser
#
if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

#
# Editors
#
export EDITOR='emacs'
export VISUAL='emacs'
export PAGER='less'

#
# Language
#
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

#
# Paths
#
export PYTHONPATH="$PYTHONPATH"

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
# Prepend GNU coreutils/findutils/sed/tar/grep ahead of BSD defaults so
# `ls`, `find`, `sed`, `tar`, `grep`, `date`, `readlink`, ... resolve to
# the GNU versions without needing `g`-prefixed aliases.
HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-/opt/homebrew}
for _pkg in coreutils findutils gnu-sed gnu-tar grep; do
  path=($HOMEBREW_PREFIX/opt/$_pkg/libexec/gnubin $path)
  manpath=($HOMEBREW_PREFIX/opt/$_pkg/libexec/gnuman $manpath)
done
path=($HOMEBREW_PREFIX/opt/gnu-getopt/bin $path)
unset _pkg

path=(
  $HOME/{,s}bin(N)
  /opt/{homebrew,local}/{,s}bin(N)
  /usr/local/{,s}bin(N)
  $path
)

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

#
# Temporary Files
#

if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"
