# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
[[ -f /share/apps/bashrc ]] && source /share/apps/bashrc

# My personal definitions
source ~/.bash_defs
