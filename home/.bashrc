# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
#
# NOTE: Use this file as ~/.bashrc to configure bash to XDG specification

# Configure bash to XDG specification

bash_config_home=${XDG_CONFIG_HOME:-$HOME/.config}/bash
bash_state_home=${XDG_STATE_HOME:-$HOME/.local/state}/bash

[ -f "$bash_config_home/.bashrc}" ] && . "$bash_config_home/bashrc}"

[ ! -d "$bash_state_home" ] && mkdir -p "$bash_state_home"

export HISTFILE="$bash_state_home/history"

unset bash_config_home
unset bash_state_home
