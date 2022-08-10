# prompt settings

prompt_time() {
  prompt_segment white $PRIMARY_FG ' %* '
}

prompt_pyenv_conda() {
  if [[ -n $VIRTUAL_ENV ]]; then
    # skip pyenv python if venv set
    return
  fi
  if [[ -n $CONDA_PROMPT_MODIFIER ]]; then
      prompt_segment cyan $PRIMARY_FG ${CONDA_PROMPT_MODIFIER//[[:space:]]/}
  elif [[ -n $PYENV_SHELL ]]; then
    local version
    version=${(@)$(pyenv version)[1]}
    if [[ $version != system ]]; then
      prompt_segment cyan $PRIMARY_FG "py-$version"
    fi
  fi
}

SHOW_AWS_PROMPT=true
ZSH_THEME_AWS_PREFIX="☁️  "
ZSH_THEME_AWS_SUFFIX=" "

AGNOSTER_PROMPT_SEGMENTS=(
  "prompt_status"
#   "prompt_context"
#   "prompt_time"
  "prompt_virtualenv"
  "prompt_pyenv_conda"
  "prompt_dir"
  "prompt_git"
  "prompt_end"
)
