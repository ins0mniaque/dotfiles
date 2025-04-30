# Configure Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Reclaim Ctrl-S / Ctrl-Q
stty -ixon -ixoff

# Add .NET Core SDK tools
export PATH="$PATH:$HOME/.dotnet/tools"

# Add Go SDK tools
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

# Disable telemetry
export DO_NOT_TRACK=1
export DISABLE_TELEMETRY=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export HF_HUB_DISABLE_TELEMETRY=1