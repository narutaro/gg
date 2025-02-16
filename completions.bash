# gg completion                                            -*- shell-script -*-

# This bash completions script was generated by
# completely (https://github.com/dannyben/completely)
# Modifying it manually is not recommended

_gg_completions_filter() {
  local words="$1"
  local cur=${COMP_WORDS[COMP_CWORD]}
  local result=()

  if [[ "${cur:0:1}" == "-" ]]; then
    echo "$words"

  else
    for word in $words; do
      [[ "${word:0:1}" != "-" ]] && result+=("$word")
    done

    echo "${result[*]}"

  fi
}

_gg_completions() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local compwords=("${COMP_WORDS[@]:1:$COMP_CWORD-1}")
  local compline="${compwords[*]}"

  case "$compline" in
    'remote-deployment targets'*)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help -h")" -- "$cur")
      ;;

    'component versions public'*)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help -h")" -- "$cur")
      ;;

    'component versions custom'*)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help -h")" -- "$cur")
      ;;

    'remote-deployment status'*)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help -h")" -- "$cur")
      ;;

    'remote-deployment deploy'*)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help --wait -h -w")" -- "$cur")
      ;;

    'local-deployment status'*)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help -h")" -- "$cur")
      ;;

    'local-deployment remove'*)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help -h")" -- "$cur")
      ;;

    'local-deployment deploy'*)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help -h")" -- "$cur")
      ;;

    'remote-deployment view'*)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help -h")" -- "$cur")
      ;;

    'remote-deployment pull'*)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help -h")" -- "$cur")
      ;;

    'remote-deployment init'*)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help --template -h -t")" -- "$cur")
      ;;

    'component pipeline'*)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help -h")" -- "$cur")
      ;;

    'component versions'*)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help -h custom public")" -- "$cur")
      ;;

    'remote-deployment'*)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help -h deploy init pull status targets view")" -- "$cur")
      ;;

    'component create'*)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help -h")" -- "$cur")
      ;;

    'local-deployment'*)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help -h deploy remove status")" -- "$cur")
      ;;

    'component build'*)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help -h")" -- "$cur")
      ;;

    'component push'*)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help -h")" -- "$cur")
      ;;

    'component init'*)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help --template -h -t")" -- "$cur")
      ;;

    'component'*)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help -h build create init pipeline push versions")" -- "$cur")
      ;;

    'template'*)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help -h")" -- "$cur")
      ;;

    *)
      while read -r; do COMPREPLY+=("$REPLY"); done < <(compgen -W "$(_gg_completions_filter "--help --version -h -v component local-deployment remote-deployment template")" -- "$cur")
      ;;

  esac
} &&
  complete -F _gg_completions gg

# ex: filetype=sh
