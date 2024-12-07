# Configure default programs
$Env:EDITOR = "nvim"
$Env:VISUAL = "nvim"
$Env:BROWSER = "open"
$Env:LOCKPRG = "lock neo"
$Env:MANPAGER = "sh -c 'col -bx | bat -l man -p'"
$Env:PAGER = "less"
$Env:LESS = "FRX --mouse"

# Autocompletion
try   { Set-PSReadLineOption -PredictionSource History }
catch { [Console]::ForegroundColor = 'Yellow'; [Console]::Error.Write("WARNING: "); [Console]::ResetColor(); [Console]::Error.WriteLine($_) }
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

# Configure zoxide
Invoke-Expression (& { (zoxide init powershell --cmd j | Out-String) })

# Configure fzf
$Env:FZF_DEFAULT_COMMAND = "fd --type f"
$Env:FZF_DEFAULT_OPTS = "--multi --bind 'ctrl-p:toggle-preview+change-preview(preview {})'"

# Install Starship
$Env:STARSHIP_CONFIG = "$HOME/.config/starship/starship.ansi.toml"
Invoke-Expression (&starship init powershell)

# Aliases
switch -regex -file ~/.config/aliases
{
    "^\s*alias\s*(.+?)\s*=\s*?(.*)"
    {
        New-Item -Path function: -Name "script:$($matches[1])" -Value $matches[2].Trim("""").Trim("'") | Out-Null
    }
}