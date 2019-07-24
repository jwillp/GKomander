#!/usr/bin/env bash

_gk_projects_completions () { 
  local cur
  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  k=0
  i="$GK_PROJ_DIR" # the directory from where to start
  for j in $( compgen -f "$i/$cur" ); do # loop trough the possible completions
    [ -d "$j" ] && j="${j}/" || j="${j} " # if its a dir add a shlash, else a space
    COMPREPLY[k++]=${j#$i/} # remove the directory prefix from the array
  done
  return 0
}

complete -o nospace -F _gk_projects_completions gk