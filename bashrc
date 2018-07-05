# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# I require that vim be installed!
export EDITOR=vim

# Make sure that ${MYBIN} is prepended to PATH.
MYBIN=${HOME}/Local/bin
if ! echo ${PATH} | grep "${MYBIN}" > /dev/null; then
   export PATH=${MYBIN}:${PATH}
fi

# Put into history neither duplicate lines nor any line starting with space.
# For setting history length see HISTSIZE and HISTFILESIZE in bash(1).
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend # Append to the history file; don't overwrite it.

# check the window size after each command and, if necessary, update the values
# of LINES and COLUMNS.
shopt -s checkwinsize

# Check for terminal's support of color.
case "$TERM" in
   xterm-color|*-256color|screen*|xterm-kitty)
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

# This is largely (but perhaps not entirely) superseded by powerline.
#my_prompt() {
#   if [ $? = 0 ]; then
#      warn=no
#   else
#      warn=yes
#   fi
#   uname=$(whoami)
#   my_pwd=`echo $PWD | sed "s,^/home/$uname,~,"`
#   my_pwd_long=`echo $my_pwd | sed 's,^\([^/]*/[^/]*/\).*\(/[^/]*/[^/]*\),\1...\2,'`
#   my_pwd_shrt=`echo $my_pwd | sed 's,^\([^/]*/\).*\(/[^/]*/[^/]*\),\1...\2,'`
#   if [ "$color_prompt" = yes ]; then
#      if [ "$warn" = yes ]; then
#         PS1='\[$(tput setab 1)$(tput setaf 3)\] \u@\h \[$(tput sgr0)\] ${my_pwd_long} \$ '
#      else
#         PS1='\[$(tput setab 7)$(tput setaf 4)\] \u@\h \[$(tput sgr0)\] ${my_pwd_long} \$ '
#      fi
#   else
#      if [ "$warn" = yes ]; then
#         PS1='(PREV_CMD_ERR) \u@\h:${my_pwd_long}\$ '
#      else
#         PS1='\u@\h:${my_pwd_long}\$ '
#      fi
#   fi
#   case "$TERM" in
#      xterm*|rxvt*|screen*)
#         # Set title as my_pwd_shrt only.
#         PS1="\[\e]0;${my_pwd_shrt}\a\]$PS1"
#         ;;
#      *)
#         ;;
#   esac
#}
#
#export PROMPT_COMMAND=my_prompt
#case "$TERM" in
#   xterm*|rxvt*|screen*)
#      # Show the currently running command in the terminal title:
#      # https://mg.pov.lt/blog/bash-prompt.html
#      # http://www.davidpashley.com/articles/xterm-titles-with-bash.html
#      show_command_in_title_bar()
#      {
#         case "$BASH_COMMAND" in
#            *\033]0*)
#               # The command itself is trying to set the title bar as well;
#               # this is most likely the execution of $PROMPT_COMMAND.  Nested
#               # escapes confuse the terminal, so don't output them.
#               ;;
#            *)
#               echo -ne "\033]0;${BASH_COMMAND}\007"
#               ;;
#         esac
#      }
#      trap show_command_in_title_bar DEBUG
#      ;;
#   *)
#      ;;
#esac


# added by Miniconda3 installer
export PATH="/opt/miniconda3/bin:$PATH"

if [ "$TERM" = "mlterm" ]; then
   export GNUTERM=sixelgd
fi

POWERLINE_SH="/usr/share/powerline/bindings/bash/powerline.sh"
if [ -f "$POWERLINE_SH" ]; then
   powerline-daemon -q
   POWERLINE_BASH_CONTINUATION=1
   POWERLINE_BASH_SELECT=1
   . "$POWERLINE_SH"
fi

