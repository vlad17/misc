# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
[[ -f /share/apps/bash_profile ]] && source /share/apps/bash_profile

export PATH=$PATH:$HOME/bin

