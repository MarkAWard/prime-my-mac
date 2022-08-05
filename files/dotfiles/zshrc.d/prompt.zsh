# prompt settings

prompt_time() {
  prompt_segment white $PRIMARY_FG ' %* '
}

prompt_pyenv() {
  if [[ -n $VIRTUAL_ENV ]]; then
    # skip pyenv python if venv set
    return
  fi
  if [[ -n $PYENV_SHELL ]]; then
    local version
    version=${(@)$(pyenv version)[1]}
    if [[ $version != system ]]; then
      prompt_segment green $PRIMARY_FG "py-$version"
    fi
  fi
}

AGNOSTER_PROMPT_SEGMENTS=(
  "prompt_status"
#   "prompt_context"
#   "prompt_time"
  "prompt_virtualenv"
  "prompt_pyenv"
  "prompt_dir"
  "prompt_git"
  "prompt_end"
)
