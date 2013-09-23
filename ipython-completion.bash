#!/bin/bash
# complete ipython

_getOps ()
{
  local cmd="$1"
  echo $(ipython $cmd --help | grep -o "^--\?[a-zA-Z][^< ]*" )
}

_cleanCur ()
{
  if [ "$cur" == "=" ] 
  then
      cur=''
  fi
}
_ipython()
{
  cur=${COMP_WORDS[COMP_CWORD]}
  local first=${COMP_WORDS[0]}
  local prev=${COMP_WORDS[COMP_CWORD-1]}
  local cmd=${COMP_WORDS[1]}
  if [ ${prev} == '=' ]
  then
      prev="${COMP_WORDS[COMP_CWORD-2]}"
  fi
  
  local subcmds="locate profile console kernel \
           notebook nbconvert qtconsole history"

  local subcmds_prof="create list"
  local subcmds_loc="profile"
  local subcmds_hist="trim"
  local mpl_backend="auto gtk inline osx qt qt4 tk wx"

  case "$prev" in
   --to)
     _cleanCur
     COMPREPLY=( $( compgen -W "latex html slides rst markdown python" -- $cur ) )
     return 0
     ;;
   --post)
     _cleanCur
     case "${COMP_WORDS[@]}" in 
      *"html"*|*"slides"*)
         local postopts="serve"
         ;;
      *"latex"*)
         local postopts="pdf"
         ;;
     esac
     COMPREPLY=( $( compgen -W "$postopts" -- $cur ) )
     return 0
     ;;
   --matplotlib | --pylab)
     _cleanCur
     COMPREPLY=( $( compgen -W "${mpl_backend}" -- $cur) )
     return 0
     ;;
   --template)
     _cleanCur
     case "${COMP_WORDS[@]}" in 
      *"html"*|*"slides"*)
         local tempopts="basic full"
         ;;
      *"latex"*)
         local tempopts="basic book article"
         ;;
     esac
     COMPREPLY=( $( compgen -W "$postopts" -- $cur ) )
     return 0
     ;;
   --config)
     _cleanCur
     COMPREPLY=( $( compgen -f -o filenames -X '.[^./]*' -- $cur) )
     return 0
     ;;
  esac
 

  case "$cmd" in
   nbconvert|notebook)
     case "$cur" in
     -*)
       local options="$(_getOps $cmd)"
       COMPREPLY=( $( compgen -W "${options} --help --help-all" -- $cur ) )
       return 0
       ;;
     *)
       _filedir ipynb
       return 0
       ;;
     esac
     ;;
   profile)
     local options="$(_getOps $cmd)"
     COMPREPLY=( $( compgen -W "${options} --help --help-all ${subcmds_prof}" -- $cur ) )
    return 0
     ;;
   locate)
     local options="$(_getOps $cmd)"
     COMPREPLY=( $( compgen -W "${options} --help --help-all ${subcmds_loc}" -- $cur ) )
     return 0
     ;;
   kernel|console|qtconsole)
     local options="$(_getOps $cmd)"
     COMPREPLY=( $( compgen -W "${options} --help --help-all" -- $cur ) )
     return 0
     ;;
   history)
     local options="$(_getOps 'history')"
     COMPREPLY=( $( compgen -W "${options} --help --help-all ${subcmds_hist}" -- $cur ) )
     return 0
     ;;
   help)
     COMPREPLY=( $( compgen -W "${subcmds}" -- $cur ) )
     return 0
     ;;
  esac

  # basic completion
  case "$cur" in
     -*)
          local options="$(_getOps)"
          COMPREPLY=( $( compgen -W "${options} --help --help-all -h" -- $cur ) )
          return 0
          ;;
      *)
          #_init_completion -s
          _filedir py
          COMPREPLY+=( $( compgen -W "${subcmds} help"  -- $cur ) )
          #COMPREPLY=( ${COMPREPLY[@]} $( compgen -f -o filenames -X '.[^./]*' -- $cur | grep *.py) )
          #COMPREPLY=( ${COMPREPLY[@]} $( compgen -W "${dirlist}" -- ${cur}) )
          #COMPREPLY=( ${COMPREPLY[@]} $( compgen -d -o dirnames -S "/" -X '.[^./]*' -- ${cur}) )
          return 0
          ;;
  esac
}
complete -F _ipython -o nospace ipython
#complete -F _ipython ipython
