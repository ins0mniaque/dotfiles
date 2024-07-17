# Configure Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Configure applications to XDG specification
source $HOME/.config/xdg/configure

# Reclaim Ctrl-S / Ctrl-Q
stty -ixon -ixoff

# Add .NET Core SDK tools
export PATH="$PATH:$HOME/.dotnet/tools"

# Configure .NET telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Add Go SDK tools
export GOPATH=$HOME/.go
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

# Add local bin
export PATH="$PATH:$HOME/.local/bin"