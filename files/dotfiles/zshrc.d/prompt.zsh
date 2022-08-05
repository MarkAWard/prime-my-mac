# prompt settings

prompt_time() {
  prompt_segment white $PRIMARY_FG ' %* '
}

AGNOSTER_PROMPT_SEGMENTS=(
  "prompt_status"
#   "prompt_context"
  "prompt_time"
  "prompt_virtualenv"
  "prompt_dir"
  "prompt_git"
  "prompt_end"
)
