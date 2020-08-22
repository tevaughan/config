# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

echo "running $HOME/.bashrc"

umask o-w  # Disallow non-user, non-group permission to write.

# Put into history neither duplicate lines nor any line starting with space.
# For setting history length see HISTSIZE and HISTFILESIZE in bash(1).
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend # Append to the history file; don't overwrite it.

# check the window size after each command and, if necessary, update the values
# of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Check for terminal's support of color.
case "$TERM" in
   xterm-kitty)
      color_prompt=yes
      if ! which kitty > /dev/null; then
         export TERM=xterm
      fi
      ;;
   xterm-*|*-256color|screen*)
      color_prompt=yes
      ;;
   *)
      if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
         # We have color support; assume it's compliant with Ecma-48
         # (ISO/IEC-6429). (Lack of such support is extremely rare, and such a
         # case would tend to support setf rather than setaf.)
         color_prompt=yes
      else
         color_prompt=
      fi
      ;;
esac

if [ "$color_prompt" = "yes" ]; then
   # Enable color support in ls, grep, and GCC.
   if [ -x /usr/bin/dircolors ]; then
      dircolors_conf=~/.config/dircolors
      if [ -r "$dircolors_conf" ]; then
         echo -n "loading dircolors from '$dircolors_conf' ... "
         eval "$(dircolors -b $dircolors_conf)"
         echo "done"
      else
         eval "$(dircolors -b)"
      fi
   fi
   alias ls='/bin/ls --color=auto'
   alias grep='/bin/grep --color=auto'
   # colored GCC warnings and errors
   export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
else
   alias ls='/bin/ls -F'
fi

# Environment variables.
environment_conf=~/.config/environment
if [ -r "$environment_conf" ]; then
  echo -n "loading environment from '$environment_conf' ... "
  . "$environment_conf"
  echo "done"
fi

# Aliases.
alias ll='ls -Aho'
alias la='ls -Ahs'
aliases_conf=~/.config/aliases
if [ -r "$aliases_conf" ]; then
  echo -n "loading aliases from '$aliases_conf' ... "
  . "$aliases_conf"
  echo "done"
fi

# Change terminal's title, and print a status-line before PS1 is printed.
__prompt_command() {
  local e="$?"                                      # This needs to be first.
  echo -ne "\033]0;${USER}@${HOSTNAME}\007"         # Change terminal's title.
  # Print status-line without termination.
  tput rev; echo -n "${PWD}"; tput sgr0
  # Possibly print error-code, and terminate in any event.
  if [ $e != 0 ]; then
    tput setaf 1; echo " $e"; tput sgr0  # Print return-code in red.
  else
    echo ""
  fi
}

export PROMPT_COMMAND=__prompt_command
export PS1="\u@\h \$ "

# Enable programmable completion features. (You don't need to enable this if it
# be already enabled in /etc/bash.bashrc and /etc/profile sources
# /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ "$TERM" = "mlterm" ]; then
   export GNUTERM=sixelgd
fi

