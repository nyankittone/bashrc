#
# /etc/bash.bashrc
#

# The MIT License
#
# Copyright (c) 2025 nyankittone
# Copyright (c) 2017 Ryan Caloras and contributors (see https://github.com/rcaloras/bash-preexec)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
# to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies
# or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
# PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
# FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ $DISPLAY ]] && shopt -s checkwinsize

case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'

    ;;
  screen*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
    ;;
esac

# don't put duplicate lines in the history.
HISTCONTROL=ignoredups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

shopt -s autocd

# Might remove this option leter, honestly. I feel like I'll just constantly
# run commands with ">|", thus making this setting pointless.
#set -o noclobber

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

unset color_prompt force_color_prompt

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Ideally, this file here would contain some non-environment variable
# definitions, for variables that you want to use in bash buit not
# be accesible outside of that, or be seen by other programs.
if [ -r '/etc/shell-variables' ]; then
    . '/etc/shell-variables'
fi

# The following is the bash-preexec plugin (https://github.com/rcaloras/bash-preexec) for Bash
# that I just copy-pasted into this file to improve portability. lol
# So, uh, yeah, here's the license to that plugin ig
# The MIT License
#
# Copyright (c) 2017 Ryan Caloras and contributors (see https://github.com/rcaloras/bash-preexec)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# # Tell shellcheck what kind of file this is.
# # shellcheck shell=bash
#
# # Make sure this is bash that's running and return otherwise.
# # Use POSIX syntax for this line:
# if [ -z "${BASH_VERSION-}" ]; then
#     return 1;
# fi
#
# # We only support Bash 3.1+.
# # Note: BASH_VERSINFO is first available in Bash-2.0.
# if [[ -z "${BASH_VERSINFO-}" ]] || (( BASH_VERSINFO[0] < 3 || (BASH_VERSINFO[0] == 3 && BASH_VERSINFO[1] < 1) )); then
#     return 1
# fi
#
# # Avoid duplicate inclusion
# if [[ -n "${bash_preexec_imported:-}" ]]; then
#     return 0
# fi
bash_preexec_imported="defined"

# WARNING: This variable is no longer used and should not be relied upon.
# Use ${bash_preexec_imported} instead.
# shellcheck disable=SC2034
__bp_imported="${bash_preexec_imported}"

# Should be available to each precmd and preexec
# functions, should they want it. $? and $_ are available as $? and $_, but
# $PIPESTATUS is available only in a copy, $BP_PIPESTATUS.
# TODO: Figure out how to restore PIPESTATUS before each precmd or preexec
# function.
__bp_last_ret_value="$?"
BP_PIPESTATUS=("${PIPESTATUS[@]}")
__bp_last_argument_prev_command="$_"

__bp_inside_precmd=0
__bp_inside_preexec=0

# Initial PROMPT_COMMAND string that is removed from PROMPT_COMMAND post __bp_install
__bp_install_string=$'__bp_trap_string="$(trap -p DEBUG)"\ntrap - DEBUG\n__bp_install'

# Fails if any of the given variables are readonly
# Reference https://stackoverflow.com/a/4441178
__bp_require_not_readonly() {
  local var
  for var; do
    if ! ( unset "$var" 2> /dev/null ); then
      echo "bash-preexec requires write access to ${var}" >&2
      return 1
    fi
  done
}

# Remove ignorespace and or replace ignoreboth from HISTCONTROL
# so we can accurately invoke preexec with a command from our
# history even if it starts with a space.
__bp_adjust_histcontrol() {
    local histcontrol
    histcontrol="${HISTCONTROL:-}"
    histcontrol="${histcontrol//ignorespace}"
    # Replace ignoreboth with ignoredups
    if [[ "$histcontrol" == *"ignoreboth"* ]]; then
        histcontrol="ignoredups:${histcontrol//ignoreboth}"
    fi;
    export HISTCONTROL="$histcontrol"
}

# This variable describes whether we are currently in "interactive mode";
# i.e. whether this shell has just executed a prompt and is waiting for user
# input.  It documents whether the current command invoked by the trace hook is
# run interactively by the user; it's set immediately after the prompt hook,
# and unset as soon as the trace hook is run.
__bp_preexec_interactive_mode=""

# These arrays are used to add functions to be run before, or after, prompts.
declare -a precmd_functions
declare -a preexec_functions

# Trims leading and trailing whitespace from $2 and writes it to the variable
# name passed as $1
__bp_trim_whitespace() {
    local var=${1:?} text=${2:-}
    text="${text#"${text%%[![:space:]]*}"}"   # remove leading whitespace characters
    text="${text%"${text##*[![:space:]]}"}"   # remove trailing whitespace characters
    printf -v "$var" '%s' "$text"
}


# Trims whitespace and removes any leading or trailing semicolons from $2 and
# writes the resulting string to the variable name passed as $1. Used for
# manipulating substrings in PROMPT_COMMAND
__bp_sanitize_string() {
    local var=${1:?} text=${2:-} sanitized
    __bp_trim_whitespace sanitized "$text"
    sanitized=${sanitized%;}
    sanitized=${sanitized#;}
    __bp_trim_whitespace sanitized "$sanitized"
    printf -v "$var" '%s' "$sanitized"
}

# This function is installed as part of the PROMPT_COMMAND;
# It sets a variable to indicate that the prompt was just displayed,
# to allow the DEBUG trap to know that the next command is likely interactive.
__bp_interactive_mode() {
    __bp_preexec_interactive_mode="on";
}


# This function is installed as part of the PROMPT_COMMAND.
# It will invoke any functions defined in the precmd_functions array.
__bp_precmd_invoke_cmd() {
    # Save the returned value from our last command, and from each process in
    # its pipeline. Note: this MUST be the first thing done in this function.
    # BP_PIPESTATUS may be unused, ignore
    # shellcheck disable=SC2034

    __bp_last_ret_value="$?" BP_PIPESTATUS=("${PIPESTATUS[@]}")

    # Don't invoke precmds if we are inside an execution of an "original
    # prompt command" by another precmd execution loop. This avoids infinite
    # recursion.
    if (( __bp_inside_precmd > 0 )); then
      return
    fi
    local __bp_inside_precmd=1

    # Invoke every function defined in our function array.
    local precmd_function
    for precmd_function in "${precmd_functions[@]}"; do

        # Only execute this function if it actually exists.
        # Test existence of functions with: declare -[Ff]
        if type -t "$precmd_function" 1>/dev/null; then
            __bp_set_ret_value "$__bp_last_ret_value" "$__bp_last_argument_prev_command"
            # Quote our function invocation to prevent issues with IFS
            "$precmd_function"
        fi
    done

    __bp_set_ret_value "$__bp_last_ret_value"
}

# Sets a return value in $?. We may want to get access to the $? variable in our
# precmd functions. This is available for instance in zsh. We can simulate it in bash
# by setting the value here.
__bp_set_ret_value() {
    return ${1:+"$1"}
}

__bp_in_prompt_command() {

    local prompt_command_array IFS=$'\n;'
    read -rd '' -a prompt_command_array <<< "${PROMPT_COMMAND[*]:-}"

    local trimmed_arg
    __bp_trim_whitespace trimmed_arg "${1:-}"

    local command trimmed_command
    for command in "${prompt_command_array[@]:-}"; do
        __bp_trim_whitespace trimmed_command "$command"
        if [[ "$trimmed_command" == "$trimmed_arg" ]]; then
            return 0
        fi
    done

    return 1
}

# This function is installed as the DEBUG trap.  It is invoked before each
# interactive prompt display.  Its purpose is to inspect the current
# environment to attempt to detect if the current command is being invoked
# interactively, and invoke 'preexec' if so.
__bp_preexec_invoke_exec() {

    # Save the contents of $_ so that it can be restored later on.
    # https://stackoverflow.com/questions/40944532/bash-preserve-in-a-debug-trap#40944702
    __bp_last_argument_prev_command="${1:-}"
    # Don't invoke preexecs if we are inside of another preexec.
    if (( __bp_inside_preexec > 0 )); then
      return
    fi
    local __bp_inside_preexec=1

    # Checks if the file descriptor is not standard out (i.e. '1')
    # __bp_delay_install checks if we're in test. Needed for bats to run.
    # Prevents preexec from being invoked for functions in PS1
    if [[ ! -t 1 && -z "${__bp_delay_install:-}" ]]; then
        return
    fi

    if [[ -n "${COMP_LINE:-}" ]]; then
        # We're in the middle of a completer. This obviously can't be
        # an interactively issued command.
        return
    fi
    if [[ -z "${__bp_preexec_interactive_mode:-}" ]]; then
        # We're doing something related to displaying the prompt.  Let the
        # prompt set the title instead of me.
        return
    else
        # If we're in a subshell, then the prompt won't be re-displayed to put
        # us back into interactive mode, so let's not set the variable back.
        # In other words, if you have a subshell like
        #   (sleep 1; sleep 2)
        # You want to see the 'sleep 2' as a set_command_title as well.
        if [[ 0 -eq "${BASH_SUBSHELL:-}" ]]; then
            __bp_preexec_interactive_mode=""
        fi
    fi

    if  __bp_in_prompt_command "${BASH_COMMAND:-}"; then
        # If we're executing something inside our prompt_command then we don't
        # want to call preexec. Bash prior to 3.1 can't detect this at all :/
        __bp_preexec_interactive_mode=""
        return
    fi

    local this_command
    this_command=$(
        export LC_ALL=C
        HISTTIMEFORMAT='' builtin history 1 | sed '1 s/^ *[0-9][0-9]*[* ] //'
    )

    # Sanity check to make sure we have something to invoke our function with.
    if [[ -z "$this_command" ]]; then
        return
    fi

    # Invoke every function defined in our function array.
    local preexec_function
    local preexec_function_ret_value
    local preexec_ret_value=0
    for preexec_function in "${preexec_functions[@]:-}"; do

        # Only execute each function if it actually exists.
        # Test existence of function with: declare -[fF]
        if type -t "$preexec_function" 1>/dev/null; then
            __bp_set_ret_value "${__bp_last_ret_value:-}"
            # Quote our function invocation to prevent issues with IFS
            "$preexec_function" "$this_command"
            preexec_function_ret_value="$?"
            if [[ "$preexec_function_ret_value" != 0 ]]; then
                preexec_ret_value="$preexec_function_ret_value"
            fi
        fi
    done

    # Restore the last argument of the last executed command, and set the return
    # value of the DEBUG trap to be the return code of the last preexec function
    # to return an error.
    # If `extdebug` is enabled a non-zero return value from any preexec function
    # will cause the user's command not to execute.
    # Run `shopt -s extdebug` to enable
    __bp_set_ret_value "$preexec_ret_value" "$__bp_last_argument_prev_command"
}

__bp_install() {
    # Exit if we already have this installed.
    if [[ "${PROMPT_COMMAND[*]:-}" == *"__bp_precmd_invoke_cmd"* ]]; then
        return 1;
    fi

    trap '__bp_preexec_invoke_exec "$_"' DEBUG

    # Preserve any prior DEBUG trap as a preexec function
    local prior_trap
    # we can't easily do this with variable expansion. Leaving as sed command.
    # shellcheck disable=SC2001
    prior_trap=$(sed "s/[^']*'\(.*\)'[^']*/\1/" <<<"${__bp_trap_string:-}")
    unset __bp_trap_string
    if [[ -n "$prior_trap" ]]; then
        eval '__bp_original_debug_trap() {
          '"$prior_trap"'
        }'
        preexec_functions+=(__bp_original_debug_trap)
    fi

    # Adjust our HISTCONTROL Variable if needed.
    __bp_adjust_histcontrol

    # Issue #25. Setting debug trap for subshells causes sessions to exit for
    # backgrounded subshell commands (e.g. (pwd)& ). Believe this is a bug in Bash.
    #
    # Disabling this by default. It can be enabled by setting this variable.
    if [[ -n "${__bp_enable_subshells:-}" ]]; then

        # Set so debug trap will work be invoked in subshells.
        set -o functrace > /dev/null 2>&1
        shopt -s extdebug > /dev/null 2>&1
    fi;

    local existing_prompt_command
    # Remove setting our trap install string and sanitize the existing prompt command string
    existing_prompt_command="${PROMPT_COMMAND:-}"
    # Edge case of appending to PROMPT_COMMAND
    existing_prompt_command="${existing_prompt_command//$__bp_install_string/:}" # no-op
    existing_prompt_command="${existing_prompt_command//$'\n':$'\n'/$'\n'}" # remove known-token only
    existing_prompt_command="${existing_prompt_command//$'\n':;/$'\n'}" # remove known-token only
    __bp_sanitize_string existing_prompt_command "$existing_prompt_command"
    if [[ "${existing_prompt_command:-:}" == ":" ]]; then
        existing_prompt_command=
    fi

    # Install our hooks in PROMPT_COMMAND to allow our trap to know when we've
    # actually entered something.
    PROMPT_COMMAND='__bp_precmd_invoke_cmd'
    PROMPT_COMMAND+=${existing_prompt_command:+$'\n'$existing_prompt_command}
    if (( BASH_VERSINFO[0] > 5 || (BASH_VERSINFO[0] == 5 && BASH_VERSINFO[1] >= 1) )); then
        PROMPT_COMMAND+=('__bp_interactive_mode')
    else
        # shellcheck disable=SC2179 # PROMPT_COMMAND is not an array in bash <= 5.0
        PROMPT_COMMAND+=$'\n__bp_interactive_mode'
    fi

    # Add two functions to our arrays for convenience
    # of definition.
    precmd_functions+=(precmd)
    preexec_functions+=(preexec)

    # Invoke our two functions manually that were added to $PROMPT_COMMAND
    __bp_precmd_invoke_cmd
    __bp_interactive_mode
}

# Sets an installation string as part of our PROMPT_COMMAND to install
# after our session has started. This allows bash-preexec to be included
# at any point in our bash profile.
__bp_install_after_session_init() {
    # bash-preexec needs to modify these variables in order to work correctly
    # if it can't, just stop the installation
    __bp_require_not_readonly PROMPT_COMMAND HISTCONTROL HISTTIMEFORMAT || return

    local sanitized_prompt_command
    __bp_sanitize_string sanitized_prompt_command "${PROMPT_COMMAND:-}"
    if [[ -n "$sanitized_prompt_command" ]]; then
        # shellcheck disable=SC2178 # PROMPT_COMMAND is not an array in bash <= 5.0
        PROMPT_COMMAND=${sanitized_prompt_command}$'\n'
    fi;
    # shellcheck disable=SC2179 # PROMPT_COMMAND is not an array in bash <= 5.0
    PROMPT_COMMAND+=${__bp_install_string}
}

# Run our install so long as we're not delaying it.
if [[ -z "${__bp_delay_install:-}" ]]; then
    __bp_install_after_session_init
fi;

# Okay, this right here marks the end of the plugin. The stuff below this is just my own stuff. :3

# Setting the variables that determine the colors of the prompt displayed.
# These variables (except for col_prompt_user and col_prompt_root) are
# accessible while the shell is being used, and can have their values
# changed, either in .bashrc or directly on the command line, to customize
# the colors used in the prompt.

# TODO: Optimize this section of the code. Maybe. idk. It works right now.
col_details_norm=37
col_details_second=97
col_time_begin=93
col_time_end=96
col_exit_success=97 # Color of the exit code if it's 0.
col_exit_fail=91    # Color of the exit code if it's not 0.
col_at=37
col_host=96         # Color of the system hostname.
col_dir=94          # Color of the working directory.
col_prompt=97
col_ps2=93          # Color of the PS2 prompt.

col_user=92  # Default color prompt if regular user.
col_root=91  # Default color prompt if root user.

# col_prompt is what's actually used for setting the prompt's color.
# Here, it is being defined based on whether or not the user is root.
if [[ $(whoami) = root ]]; then
    col_user=$col_root
fi

# Unsetting some earlier variables, to keep things clean.
unset col_root

PS1_MODE=full

buildExitDetails() {
    [[ -z $PREEXEC_TIME ]] || [[ -z $COMMAND_WAS_RUN ]] && return 1

    local curr_time=`date +%s%N`
    local curr_time_formatted="`date +%H:%M:%S`"

    # hoooooo boy, this code for getting elapsed time is really buggy. oh hot
    # mama. Good god, mama mia, what terrible code. Big yikes. Absolutely
    # astonishing. I can't believe I've done this.
    local elapsed_time=000$(expr $curr_time - $PREEXEC_TIME)

    #local elapsed_millisecs=$(expr \( $elapsed_time % 1000000000 \) / 1000000)
    local elapsed_millisecs=${elapsed_time: -9:3}

    elapsed_time=$(expr $elapsed_time / 1000000000)

    # TODO: redo the time-formatting code so that it doesn't display feilds for
    # days/hours/minutes if they have a value of zero.

    # getting seconds
    local elapsed_secs=$(expr $elapsed_time % 60)
    elapsed_time=$(expr \( $elapsed_time - $elapsed_secs \) / 60)
    elapsed_secs="${elapsed_secs}.${elapsed_millisecs}s"

    # getting minutes
    if [[ $elapsed_time -gt 0 ]]; then
        local elapsed_mins=$(expr $elapsed_time % 60)
        elapsed_time=$(expr \( $elapsed_time - $elapsed_mins \) / 60)
        elapsed_mins=${elapsed_mins}m
    fi

    # getting hours
    if [[ $elapsed_time -gt 0 ]]; then
        local elapsed_hours=$(expr $elapsed_time % 24)
        elapsed_time=$(expr \( $elapsed_time - $elapsed_hours \) / 24)
        elapsed_hours=${elapsed_hours}h
    fi

    # getting days
    if [[ $elapsed_time -gt 0 ]]; then
        local elapsed_days=${elapsed_time}d
    fi

    local formed_elapsed_time=$elapsed_days$elapsed_hours$elapsed_mins$elapsed_secs

    if [[ $1 -ne 0 ]]; then
        local exit_color="$col_exit_fail"
    else
        local exit_color="$col_details_second"
    fi

    echo "\33[0;${col_details_norm}mtook \33[1;${col_details_second}m$formed_elapsed_time \33[0;${col_details_norm}m(\33[${col_time_begin}m$PREEXEC_TIME_FORMATTED \33[${col_details_norm}m- \33[${col_time_end}m$curr_time_formatted\33[${col_details_norm}m), exit \33[1;${exit_color}m$1"

    return 0
}

preexec() {
    COMMAND_WAS_RUN=yuh

    PREEXEC_TIME=`date +%s%N`
    PREEXEC_TIME_FORMATTED=`date +%H:%M:%S`
}


# This function is run after every command execution, and is responsible
# for contructing the prompt and showing when the command finished running.
precmd() {
    local exit=$? # Grabbing the exit code of the command that was last run.

    local pre_PS1="`buildExitDetails $exit`"
    if [[ -n "$pre_PS1" ]]; then
        pre_PS1="\n${pre_PS1}\n"
    else
        pre_PS1="\n"
    fi

    # Building the PS0 value, and the text showing when the command finished
    # running.
    # Here, $PS0 is used to show when a command starts running.
#    local current_time_formatted=$(date +%H:%M:%S)
#    local pre_PS1="\n\33[1;${col_brack_end}m<\33[mnow \
#${current_time_formatted}\33[1;${col_brack_end}m>\33[m\n"
#    local work_disp="\w"
#    PS0="\[\033[1;${col_brack_start}m\]<\[\033[0m\]run \t\
#\[\033[1;${col_brack_start}m\]>\[\033[0m\]\n"

    # The PS1 variable is set up differently depending on the value of
    # PS1_MODE. "full" is how it's normally set up, "partial" makes only
    # the last directory in the working directory path get shown, and "minimal"
    # creates a truly minimalist prompt, that only prints a single $ (or # if
    # you're root).

    local work_disp="\w"

    case $PS1_MODE in
        partial)
            local work_disp="\W"
        ;;
        minimal)
            pre_PS1="\n"
            unset PS0

            if [[ $(whoami) = root ]]; then
                PS1_end="\[\033[1;${col_user}m\]#\[\033[0m\] "
            else
                PS1_end="\[\033[1;${col_user}m\]$\[\033[0m\] "
            fi

            local skip=yuh
        ;;
        *) PS1_MODE=full
        ;;
    esac

    # Displaying when the command run finished.
    printf "$pre_PS1"

    # The rest of this function below this comment is mainly responsible for
    # building the PS1 value.

    # Anything within this if statement isn't run when PS1_MODE is set to
    # "minimal".
    if [[ -z $skip ]]; then
        # Part of PS1 containing the hostname and working directory.
        local PS1_mid="\[\033[1;${col_user}m\]\u\[\033[${col_at}m\]@\[\033[${col_host}m\]\h \[\033[${col_dir}m\]${work_disp} "

        PS1_end="\[\033[1;${col_prompt}m\]>\[\033[0m\] "
    fi

    # Setting the value for PS1, as well as PS2.
    PS1="$PS1_beg$PS1_mid$PS1_end"
    PS2="\[\033[1;${col_ps2}m\]?\[\033[0m\] "

    unset COMMAND_WAS_RUN
    unset PREEXEC_TIME
    unset PREEXEC_TIME_FORMAT
}

# Creating a command for cycling the value of PS1_VALUE. "cps" is literally
# short for "cycle prompt string".
cps() {
    case $PS1_MODE in
        full) PS1_MODE=partial;;
        partial) PS1_MODE=minimal;;
        minimal) PS1_MODE=full;;
    esac
}

# Configuring the promptcmd function to actually get run after every command.
# promptcmd has to be at the very beginning here, or else it won't grab the
# exit code correctly.
#PROMPT_COMMAND="promptcmd; $PROMPT_COMMAND"

# defining some useful-ish aliases. Some of these aliases will not work
# properly if you're using non-GNU core utilities.
alias pip="pip3"
alias py="python3"

if which lsd 2>/dev/null; then
    default_ls='lsd -FAh --color=auto'
    alias lt="$default_ls --tree"
else
    default_ls='ls -FAh --color=auto'
fi

alias l="$default_ls"
alias ll="l -l"
alias cp="cp -i"
alias mv="mv -i"
alias df="df -h"
alias pu="pushd"
alias po="popd"
alias sudo="sudo "
alias md="mkdir"
alias rd="rmdir"
alias t="tmux"
alias to="touch"

# Aliasing "v" to be whatever the best version of the vi text editor is on this current machine
if which nvim > /dev/null; then
    alias v="nvim"
elif which vim > /dev/null; then
    alias v="vim"
elif which vi > /dev/null; then
    alias v="vi"
fi

if [ -n "`which clang`" ]; then
    alias ccd="clang -std=c99 -pedantic-errors -Wall"
elif [ -n "`which gcc`" ]; then
    alias ccd="gcc -std=c99 -pedantic-errors -Wall"
fi

# GNU-specific aliases
alias diff="diff --color=auto"
which ip 2> /dev/null && alias ip="ip -color=auto"
export LESS='-R --use-color -Dd+b$Du+g$'
export MANPAGER="less -R --use-color -Dd+b -Du+g" # This line seems broken somehow? I'll fix it later ig
export SUDO_PROMPT="$(tput setaf 1 bold)Enter password:$(tput sgr0) "

if [[ $(whoami) = root ]]; then
    alias rm="rm -i"
    alias chown="chown --preserve-root"
    alias chmod="chmod --preserve-root"
else
    alias rm="rm -I"
fi

# defining some extra, less useful aliases.
alias rtfm="man"
alias woman="man"
alias enby="man"
alias nb="man"
alias dog="cat"
alias c="clear"
alias ca="cava"

# overwriting dir with this funny function.
dir() { echo Use ls, you dumbass.; }

goto() {
    cd "$1"
    $default_ls -l
}

set -o vi

# clearing the screen, just to keep things neat.
clear

