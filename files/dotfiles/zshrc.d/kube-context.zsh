#!/usr/bin/env zsh
# Standarized $0 handling
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Kubernetes prompt theme configuration
SHOW_KUBE_PROMPT=false
ZSH_THEME_KUBE_PREFIX="☸ "
ZSH_THEME_KUBE_SUFFIX=" "

# Function to get current kubernetes context
function kube_prompt_info() {
  [[ -z $(command -v kubectl) ]] && return
  local kube_context=$(kubectl config current-context 2>/dev/null)
  [[ -z "$kube_context" ]] && return

  case "$kube_context" in
    docker-desktop) return ;;
    *-prod|*production*) prompt_segment red yellow "${ZSH_THEME_KUBE_PREFIX}${kube_context}${ZSH_THEME_KUBE_SUFFIX}" ;;
    *) prompt_segment blue black "${ZSH_THEME_KUBE_PREFIX}${kube_context}${ZSH_THEME_KUBE_SUFFIX}" ;;
  esac
}

# Add to RPROMPT if enabled
if [[ "$SHOW_KUBE_PROMPT" == true && "$RPROMPT" != *'$(kube_prompt_info)'* ]]; then
  RPROMPT='$(kube_prompt_info)'"$RPROMPT"
fi
