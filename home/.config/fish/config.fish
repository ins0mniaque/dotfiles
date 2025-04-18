# Configure default programs
set -g -x EDITOR nvim
set -g -x VISUAL nvim
set -g -x BROWSER open
set -g -x LOCKPRG "lock neo"
set -g -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -g -x PAGER less
set -g -x LESS "FRX --mouse"

# Add .NET Core SDK tools
fish_add_path ~/.dotnet/tools

# Configure .NET telemetry
set -g -x DOTNET_CLI_TELEMETRY_OPTOUT 1

# Add Go SDK tools
set -g -x GOPATH ~/.go
set -g -x GOROOT (brew --prefix golang)/libexec
fish_add_path $GOPATH/bin
fish_add_path $GOROOT/bin

# Add tools
fish_add_path ~/.tools/arm64
fish_add_path ~/.tools/x64

# Configure zoxide
zoxide init fish --cmd j | source

# Configure fzf
set -g -x FZF_DEFAULT_COMMAND 'fd --type f --color=always'
set -g -x FZF_DEFAULT_OPTS '--multi --bind "ctrl-p:toggle-preview+change-preview(preview {})"'

# Install Starship
set -g -x STARSHIP_CONFIG ~/.config/starship/starship.toml
starship init fish | source

# Aliases
source ~/.config/aliases

# Disable telemetry
set -g -x DO_NOT_TRACK 1
set -g -x DISABLE_TELEMETRY 1
set -g -x DOTNET_CLI_TELEMETRY_OPTOUT 1
set -g -x HF_HUB_DISABLE_TELEMETRY 1