# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
#
# NOTE: Use this file as ~/.profile to configure bash to XDG specification

if [ "${BASH-no}" != "no" ]; then

# Configure bash to XDG specification

bash_config_home=${XDG_CONFIG_HOME:-$HOME/.config}/bash
bash_state_home=${XDG_STATE_HOME:-$HOME/.local/state}/bash

[ -f "$bash_config_home/.profile}" ] && . "$bash_config_home/profile}"

[ ! -d "$bash_state_home" ] && mkdir -p "$bash_state_home"

export HISTFILE="$bash_state_home/history"

unset bash_config_home
unset bash_state_home

fi
