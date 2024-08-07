# Autocompletion
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Alias
if ($IsWindows)
{
    Set-Alias open Invoke-Item
    function su { & Start-Process pwsh -Verb runAs }
}
elseif ($IsLinux)
{
    function open { & setsid nohup xdg-open $Args > /dev/null 2> /dev/null }
}

# Add .NET Core SDK tools
$Env:Path += ";$HOME/.dotnet/tools"

# Configure .NET telemetry
$Env:DOTNET_CLI_TELEMETRY_OPTOUT = 1

# Fix PowerShell command (see https://github.com/PowerShell/PowerShell/issues/12205)
Set-Alias pwsh "$HOME/.dotnet/tools/pwsh"

# Add Go SDK tools
$Env:GOPATH = "$HOME/.go"
$Env:GOROOT = "$(brew --prefix golang)/libexec"
$Env:Path += ";$Env:GOPATH/bin;$Env:GOROOT/bin"

# Add tools
$Env:Path += ";$HOME/.tools/arm64;$HOME/.tools/x64"

# Configure Jump
Invoke-Expression (&jump shell pwsh | Out-String)

# Configure fzf
$Env:FZF_DEFAULT_COMMAND = "fd --type f"
$Env:FZF_DEFAULT_OPTS = "--multi --bind 'ctrl-p:toggle-preview+change-preview(preview {})'"

# Install Starship
$Env:STARSHIP_CONFIG = "$HOME/.config/starship/starship.ansi.toml"
Invoke-Expression (&starship init powershell)