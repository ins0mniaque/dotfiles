# Configure Homebrew
if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

source "${XDG_CONFIG_HOME:-~/.config}"/profile