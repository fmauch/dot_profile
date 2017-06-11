# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# local_install
if [ -d "$HOME/local_install/install" ] ; then
    export PATH="$HOME/local_install:$PATH"
    export CMAKE_PREFIX_PATH="$HOME/local_install/install:$CMAKE_PREFIX_PATH"
    export CPLUS_INCLUDE_PATH="$HOME/local_install/install/include:$CPLUS_INCLUDE_PATH=" 
    export C_INCLUDE_PATH="$HOME/local_install/install/include:$C_INCLUDE_PATH=" 
fi

# This is supposed to help with the nvidia refresh issue. Well, apparently it doesn't :(
export __GL_SHADER_DISK_CACHE=0

# git batch stuff
source $HOME/.profile_plugins/git_batch_functions.sh
source $HOME/.profile_plugins/ros_helper_functions.sh
source $HOME/.profile_plugins/docker_functions.sh


# default aliases
alias ls='ls --color=auto'
alias psgrep='ps -aux | grep'

if `hash yokadi 2>/dev/null`; then
  alias y='yokadi'
fi

# environment variables
export VISUAL='vim'
export EDITOR="vim"


if [ -e ~/.profile_local ]; then
  source ~/.profile_local
fi

# ack-grep like functionality for searching through pdf files
function pdf-ack-grep ()
{
  if hash pdftotext 2>/dev/null; then
    find . -name '*.pdf' -exec sh -c 'pdftotext "{}" - | grep --with-filename --label="{}" --color '"$1" \;
  else
    echo "pdftotext not found. Please install the pdftotext utility to use this function."
  fi
}
