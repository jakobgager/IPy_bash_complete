IPython bash completion
=======================

Bash complete script to get completion in the terminal.   
Works only with bash/zsh. (working on a csh/tcsh version as well)

The contained completion routines provide support for completing:
* subcommands
* options for ipython and subcommands (derived by --help)
* nbconvert --to={latex, markdown, rst, html, custom, python, slides}
* nbconvert --post={pdf, serve}
* ipython filename.py completion
* ipython {notebook, nbconvert} filename.ipynb completion

If desired the parsed options can be extended by replacing `--help` with `--help-all` in the *getOps* function.

Current limitations:
* no logic is implemented to validate combinations
* folder completion does not strip dotdirs
* option choices are not parsed but hardcoded

Install
-------
1. clone the repo into the .config/ipython directory
2. source the script / add the following line to your .bashrc/.zshrc:   

```bash
source ~/.config/ipython/IPy_bash_complete/ipython-completion.bash
```   
   
