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
  elif [[ -n $PYENV_VERSION ]]; then
    # Use PYENV_VERSION if set (faster than calling pyenv version)
    if [[ $PYENV_VERSION != system ]]; then
      prompt_segment cyan $PRIMARY_FG "py-$PYENV_VERSION"
    fi
  elif [[ -n $PYENV_SHELL ]]; then
    # Fallback: only call pyenv if PYENV_VERSION is not set
    # This is slower, so prefer setting PYENV_VERSION via pyenv init
    local version
    version=${(@)$(pyenv version-name 2>/dev/null)[1]}
    if [[ -n $version && $version != system ]]; then
      prompt_segment cyan $PRIMARY_FG "py-$version"
    fi
  fi
}

prompt_short_dir() {
  local pwd="${PWD/#$HOME/~}"
  local path_components=(${(s:/:)pwd})
  local num_components=${#path_components}

  if (( num_components > 3 )); then
    local short_path=""
    for ((i=1; i<=num_components-2; i++)); do
      short_path+="/${path_components[i][1]}"
    done
    short_path+="/${path_components[-2]}/${path_components[-1]}"
    pwd=$short_path
  fi

  #  Use 256-color codes so the path segment renders identically regardless
  #  of which ANSI palette the terminal applies and whether "draw bold in
  #  bright colors" is enabled (that feature only rewrites ANSI 0-7, so any
  #  16-255 code sidesteps it).
  #    39 = bright sky blue (#00afff)
  #    16 = pure black
  prompt_segment 39 16 " %B$pwd%b "
}

AGNOSTER_PROMPT_SEGMENTS=(
  "prompt_status"
  "prompt_time"
  # "prompt_context"
  # "prompt_virtualenv"
  # "prompt_pyenv_conda"
  # "prompt_dir"
  "prompt_short_dir"
  "prompt_git"
  "prompt_end"
)
