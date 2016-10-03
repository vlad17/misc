# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Don't treat me like a kid
if alias rm &> /dev/null ; then
    unalias rm
fi
if alias mv &> /dev/null ; then
    unalias mv
fi
if alias cp &> /dev/null ; then
    unalias cp
fi

# Stupid erase tty thing (only useful in ssh+tmux)
[[ $- == *i* ]] && stty erase ^?

# User specific aliases and functions
[[ -f /share/apps/bashrc ]] && source /share/apps/bashrc

# My personal definitions
source ~/.bash_defs
