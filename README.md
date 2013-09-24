IPython bash completion
=======================

Bash complete script to get completion in the terminal.   
Works only with bash/zsh. (working on a csh/tcsh version as well)

The contained completion routines provide support for completing:
* subcommands
* options for ipython and subcommands (derived by --help)
* nbconvert --to={latex, markdown, rst, html, custom, python, slides}
* nbconvert --post={pdf| serve} (dependent on --to)
* nbconvert --template={basic, article, book|basic, full} (dependent on --to)
* ipython filename.py completion
* ipython {notebook, nbconvert} filename.ipynb completion

The script uses the `--help` option to get all possible options.
If this is too slow, it would be possible to add a preprocessing step (not implemented).
If desired the parsed options can be extended by replacing `--help` with `--help-all` in the *getOps* function.

Current limitations:
* no logic is implemented to validate combinations
* folder completion does not strip dotdirs
* option choices are not parsed but hardcoded

Install
-------
1. clone the repo into the .config/ipython directory (or any other directory)
2. source the script / add the following line to your .bashrc/.zshrc (adapt if necessary):   

```bash
source ~/.config/ipython/IPy_bash_complete/ipython-completion.bash
```   
   
