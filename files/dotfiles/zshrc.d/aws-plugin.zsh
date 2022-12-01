#!/usr/bin/env zsh
# Standarized $0 handling, following:
# https://zplugin.readthedocs.io/en/latest/zsh-plugin-standard/
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"


# AWS list profile
function alp() {
  [[ -r "${AWS_CONFIG_FILE:-$HOME/.aws/config}" ]] || return 1
  grep --color=never -Eo '\[.*\]' "${AWS_CONFIG_FILE:-$HOME/.aws/config}" | sed -E 's/^[[:space:]]*\[(profile)?[[:space:]]*([-_[:alnum:]\.@]+)\][[:space:]]*$/\2/g'
}

# AWS get profile
function agp() {
  echo $AWS_PROFILE
}

# AWS get profile
function acp {
    unset AWS_DEFAULT_PROFILE AWS_PROFILE AWS_EB_PROFILE
    echo "AWS profile cleared."
}

# AWS select profile
function asp() {
  if [[ -z "$1" ]]; then
    acp
    asp $(alp | fzf --height 30% --border)
    return
  fi

  local -a available_profiles
  available_profiles=($(alp))
  if [[ -z "${available_profiles[(r)$1]}" ]]; then
    echo "${fg[red]}Profile '$1' not found in '${AWS_CONFIG_FILE:-$HOME/.aws/config}'" >&2
    echo "Available profiles: ${(j:, :)available_profiles:-no profiles found}${reset_color}" >&2
    return 1
  fi

  export AWS_DEFAULT_PROFILE=$1
  export AWS_PROFILE=$1
  export AWS_EB_PROFILE=$1
  echo "Switched to AWS Profile: $1"

  echo "Run gimme-aws-creds now?"
  if [[ $(echo "yes\nno" | fzf --layout=reverse --border --height 5%) == "yes" ]]; then
    aws-creds
  fi
}

# gimme-aws-creds for selected profile
function aws-creds {
    if [[ -z $AWS_PROFILE ]]; then
      echo "AWS_PROFILE is not set"
      return 1
    fi
    gimme-aws-creds --profile $AWS_PROFILE
}


function _aws_profiles() {
  reply=($(alp))
}
compctl -K _aws_profiles asp

# AWS prompt
function aws_prompt_info() {
  [[ -z $AWS_PROFILE ]] && return
#   echo "${ZSH_THEME_AWS_PREFIX:=<aws:}${AWS_PROFILE}${ZSH_THEME_AWS_SUFFIX:=>}"
  case "$AWS_PROFILE" in
    *-prod|*production*) prompt_segment red black  "${ZSH_THEME_AWS_PREFIX:=<aws:}${AWS_PROFILE}${ZSH_THEME_AWS_SUFFIX:=>}" ;;
    *) echo "${ZSH_THEME_AWS_PREFIX:=<aws:}${AWS_PROFILE}${ZSH_THEME_AWS_SUFFIX:=>}" ;;
  esac
}

prompt_aws() {
  [[ -z "$AWS_PROFILE" ]] && return
  case "$AWS_PROFILE" in
    *-prod|*production*) prompt_segment red yellow  "AWS: $AWS_PROFILE" ;;
    *) prompt_segment green black "${ZSH_THEME_AWS_PREFIX:=AWS: }$AWS_PROFILE" ;;
  esac
}


if [[ "$SHOW_AWS_PROMPT" != false && "$RPROMPT" != *'$(aws_prompt_info)'* ]]; then
  RPROMPT='$(aws_prompt_info)'"$RPROMPT"
fi
