#!/bin/bash
# complete ipython

#TODO:
# - cache options (using location and timestamp?)
# - refractor code

_getOps ()
{
  local cmd="$1"
  local opt="$2"
  opts=$((ipython $cmd --help$opt ; echo -e "--help\n--help-all\n-h") | grep -o "^--\?[a-zA-Z][^< ]*" | sed -e "s/[^=]$/& /" )
}

_getPylabModes ()
{
if [ -z "$_pylabmodes" ]; then
    _pylabmodes=`cat <<EOF | python -
try:
    import IPython.core.shellapp as mod;
    for k in mod.InteractiveShellApp.pylab.values:
        print "%s ," % k
except:
    pass
EOF
        `  
fi
}

_getIPyProfiles ()
{
if [ -z  "$_ipythonprofiles" ]; then
        _ipythonprofiles=`cat <<EOF | python -
try:
    import IPython.core.impliesprofileapp
    for k in IPython.core.profileapp.list_bundled_profiles():
        print "%s ," % k
    p = IPython.core.profileapp.ProfileList()
    for k in IPython.core.profileapp.list_profiles_in(p.ipython_dir):
        print "%s ," % k
except:
    pass
EOF
        `
fi    
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
  
  local subcmds="locate ,profile ,console ,kernel ,notebook ,nbconvert ,qtconsole ,history"
  local subcmds_prof="create ,list "
  local subcmds_loc="profile"
  local subcmds_hist="trim"
  local mpl_backend="auto ,gtk ,inline ,osx ,qt ,qt4 ,tk ,wx "

  case "$prev" in
   --to)
     _cleanCur
     local IFS=$',\t\n'
     COMPREPLY=( $( compgen -W "latex ,html ,slides ,rst ,markdown ,python " -- $cur ) )
     unset IFS
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
     _getPylabModes
     local IFS=$',\t\n'
     COMPREPLY=( $( compgen -W "${_pylabmodes}" -- $cur) )
     unset IFS
     return 0
     ;;
   --template)
     _cleanCur
     case "${COMP_WORDS[@]}" in 
      *"html"*|*"slides"*)
         local tempopts="basic ,full "
         ;;
      *"latex"*)
         local tempopts="base ,report ,article "
         ;;
     esac
     local IFS=$',\t\n'
     COMPREPLY=( $( compgen -W "$tempopts" -- $cur ) )
     return 0
     ;;
   --config)
     _cleanCur
     _filedir
     return 0
     ;;
   --profile)
     _cleanCur
     _getIPyProfiles
     local IFS=$',\t\n'
     COMPREPLY=( $( compgen -W "${_ipythonprofiles}" -- $cur) )
     unset IFS
     return 0
     ;;
  esac
 

  case "$cmd" in
   nbconvert|notebook)
     case "$cur" in
     -*)
       _getOps $cmd
       local IFS=$'\t\n'
       COMPREPLY=( $( compgen -W "${opts}" -- $cur ) )
       return 0
       ;;
     *)
       _filedir ipynb
       return 0
       ;;
     esac
     ;;
   profile)
     _getOps $cmd
     local IFS=$',\t\n'
     COMPREPLY=( $( compgen -W "${opts} ,${subcmds_prof}" -- $cur ) )
     unset IFS
     return 0
     ;;
   locate)
     _getOps $cmd
     local IFS=$'\t\n'
     COMPREPLY=( $( compgen -W "${opts} ,${subcmds_loc}" -- $cur ) )
     return 0
     ;;
   kernel|console|qtconsole)
     _getOps $cmd
     local IFS=$'\t\n'
     COMPREPLY=( $( compgen -W "${opts}" -- $cur ) )
     return 0
     ;;
   history)
     _getOps $cmd
     local IFS=$'\t\n'
     COMPREPLY=( $( compgen -W "${opts} ,${subcmds_hist}" -- $cur ) )
     return 0
     ;;
   help)
     COMPREPLY=( $( compgen -W "${subcmds}" -- $cur ) )
     return 0
     ;;
  esac

  # basic completion
  case "$cur" in
     --*)
          _getOps "" -all
          local IFS=$'\t\n'
          COMPREPLY=( $( compgen -W "${opts}" -- $cur ) )
          ;;
     -*)
          _getOps
          local IFS=$'\t\n'
          COMPREPLY=( $( compgen -W "${opts}" -- $cur ) )
          ;;
      *)
          _filedir py
          local IFS=$',\t\n'
          COMPREPLY+=( $( compgen -W "${subcmds} ,help "  -- $cur ) )
          ;;
  esac
  return 0
}
complete -F _ipython -o nospace ipython
#complete -F _ipython -o nospace ipython2.7
