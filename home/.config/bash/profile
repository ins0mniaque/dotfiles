# Reclaim Ctrl-S / Ctrl-Q
stty -ixon -ixoff

# Configure Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Configure Go SDK
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

# Profile
source "${XDG_CONFIG_HOME:-~/.config}"/profile