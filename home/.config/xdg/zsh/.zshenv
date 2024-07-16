# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
#
# NOTE: Use this file as ~/.zshenv and add the following to your .zshrc to configure zsh to XDG specification
#
#       # Configure zsh autocompletion cache to XDG specification
#       compinit -d "$ZCACHEDIR/zcompdump-$ZSH_VERSION"
#       zstyle ':completion:*' cache-path "$ZCACHEDIR"/zcompcache

# Configure XDG base directories

: ${XDG_CACHE_HOME:=~/.cache}
: ${XDG_CONFIG_HOME:=~/.config}
: ${XDG_DATA_HOME:=~/.local/share}
: ${XDG_STATE_HOME:=~/.local/state}

[[ -z $XDG_RUNTIME_DIR ]] && [[ -d "/run/user/$UID" ]] && XDG_RUNTIME_DIR="/run/user/$UID"
[[ -z $XDG_RUNTIME_DIR ]] && XDG_RUNTIME_DIR=${${TMPDIR-/tmp}%/}/runtime-user-$UID
[[ -d $XDG_RUNTIME_DIR ]] || mkdir -m 0700 -p $XDG_RUNTIME_DIR

export XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME XDG_STATE_HOME XDG_RUNTIME_DIR

# Configure zsh to XDG specification

ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}
ZCACHEDIR=${ZCACHEDIR:-$XDG_CACHE_HOME/zsh}
ZDATADIR=${ZDATADIR:-$XDG_DATA_HOME/zsh}
ZSTATEDIR=${ZSTATEDIR:-$XDG_STATE_HOME/zsh}
HISTFILE="$zsh_state_home"/zsh/history

[ ! -d "$ZCACHEDIR/zcompdump-$ZSH_VERSION" ] && mkdir -p "$ZCACHEDIR/zcompdump-$ZSH_VERSION"
[ ! -d "$ZDATADIR"  ] && mkdir -p "$ZDATADIR"
[ ! -d "$ZSTATEDIR" ] && mkdir -p "$ZSTATEDIR"

export ZDOTDIR ZCACHEDIR ZDATADIR ZSTATEDIR HISTFILE

# Source .zshenv
[ -f "$ZDOTDIR"/.zshenv ] && . "$ZDOTDIR"/.zshenv
