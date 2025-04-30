# Configure default programs
export EDITOR=nvim
export VISUAL=nvim
export BROWSER=open
export LOCKPRG="lock neo"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export PAGER=less
export LESS="FRX --mouse"

# Configure zsh autocompletion cache to XDG specification
autoload -U compinit
compinit -d "$ZCACHEDIR/zcompdump-$ZSH_VERSION"
zstyle ':completion:*' cache-path "$ZCACHEDIR"/zcompcache

# Configure keyboard
source $ZDOTDIR/plugins/zsh-modern-keybindings/zsh-modern-keybindings.zsh

# Configure auto-suggestions / syntax highlighting / history substring search
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Configure ollama completion
source $ZDOTDIR/plugins/ollama_zsh_completion/ollama_zsh_completion.plugin.zsh

# Configure dotnet completion
_dotnet_zsh_complete()
{
    local completions=("$(dotnet complete "$words")")
    if [ -z "$completions" ]; then
        _arguments '*::arguments: _normal'
        return
    fi

    _values = "${(ps:\n:)completions}"
}

compdef _dotnet_zsh_complete dotnet

# Configure zoxide
eval "$(zoxide init zsh --cmd j)"

# Configure eza
if [ -n "$NERDFONT" ]; then
    export EZA_ICONS_AUTO=1
fi

# Configure fzf
if [ "$COLORTERM" = truecolor ] || [ "$COLORTERM" = 24bit ]; then
    FZF_COLORS='--color=bg+:#293739,bg:#1B1D1E,border:#808080,spinner:#E6DB74,hl:#7E8E91,fg:#F8F8F2,header:#7E8E91,info:#A6E22E,pointer:#A6E22E,marker:#F92672,fg+:#F8F8F2,prompt:#F92672,hl+:#F92672'
else
    FZF_COLORS=''
fi

case $EDITOR in
    *vim*)   FZF_EDITOR="$EDITOR {1} +{2}" ;;
    *emacs*) FZF_EDITOR="$EDITOR +{2} {1}" ;;
    code)    FZF_EDITOR="$EDITOR {1}:{2}" ;;
    *)       FZF_EDITOR="$EDITOR {1}" ;;
esac

export FZF_DEFAULT_COMMAND="fd --strip-cwd-prefix --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND --type file"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type directory"

FZF_PREVIEW="preview --header {}"

if [ "$TERM_PROGRAM" = tmux ]; then
    FZF_DEFAULT_OPTS="--height 50% --tmux 80%"
else
    FZF_DEFAULT_OPTS="--height 99%"
fi

export FZF_DEFAULT_OPTS="
    $FZF_DEFAULT_OPTS
    --preview-window '~2,60%,border-left'
    --layout=default
    --info=inline-right
    --prompt='❯ ' --pointer='❯' --marker='☑️'
    --bind 'ctrl-p:change-preview-window(~2,75%,down,border-top|hidden|~2,60%,border-left)'
    --bind 'ctrl-d:reload($FZF_ALT_C_COMMAND)+change-preview($FZF_PREVIEW)'
    --bind 'ctrl-f:reload($FZF_CTRL_T_COMMAND)+change-preview($FZF_PREVIEW)'
    --bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'
    --bind 'ctrl-t:replace-query'
    --bind 'ctrl-s:toggle-sort'
    --bind 'ctrl-a:toggle-all'
    --bind 'ctrl-o:become($FZF_EDITOR < /dev/tty > /dev/tty)'
    --bind 'ctrl-e:execute($FZF_EDITOR)'
    --bind bspace:backward-delete-char/eof
    $FZF_COLORS"
export FZF_CTRL_T_OPTS="--preview '$FZF_PREVIEW'"
export FZF_ALT_C_OPTS="--preview '$FZF_PREVIEW'"

source <(fzf --zsh)

bindkey '^F' fzf-file-widget
bindkey '^G' fzf-cd-widget
bindkey '^H' fzf-history-widget

# Configure fzf-tab
source $ZDOTDIR/plugins/fzf-tab/fzf-tab.plugin.zsh

if [ -z "$FZF_TAB_MODULE_VERSION" ]; then
    echo "\033[33mWarning:\033[0m fzf-tab binary module is missing; run \033[32mbuild-fzf-tab-module\033[0m to build"
fi

zstyle ':completion:*' fzf-search-display true
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' menu no
zstyle ':completion:*:*:*:*:processes' command 'ps -u "$USER" -o pid,user,command -ww'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'

zstyle ':fzf-tab:*' switch-group F1 F2
zstyle ':fzf-tab:*' continuous-trigger 'tab'
zstyle ':fzf-tab:*' fzf-flags ${(Q)${(Z:nC:)FZF_DEFAULT_OPTS}}

# Configure fzf-tab previews
zstyle ':fzf-tab:complete:*:*' fzf-preview 'preview --header ${(Q)realpath}'
zstyle ':fzf-tab:complete:*:options' fzf-preview 
zstyle ':fzf-tab:complete:*:argument-1' fzf-preview
zstyle ':fzf-tab:complete:(kill|ps):*' fzf-preview
zstyle ':fzf-tab:complete:ssh:*' fzf-preview 'dig +short "$word"'
zstyle ':fzf-tab:complete:brew-(install|uninstall|search|info):*-argument-rest' fzf-preview 'brew info "$word"'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status "$word"'

zstyle ':fzf-tab:complete:(-parameter-|-brace-parameter-|export|unset|expand|typeset|declare|local):*' fzf-preview 'echo "${(P)word}"'
zstyle ':fzf-tab:complete:man:*' fzf-preview 'man "$word" | bat -p -l man --color=always'
zstyle ':fzf-tab:complete:tldr:*' fzf-preview 'tldr --color always "$word"'
zstyle ':fzf-tab:complete:-command-:*' fzf-preview \
    '(out=$(tldr --color always "$word") 2>/dev/null && echo "$out") || ' \
    '(out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo "$out") || ' \
    '(out=$(which "$word") && echo "$out") || ' \
    'echo "${(P)word}"'

git_diff_preview='git diff --color=always ${(Q)realpath:-$word} | $(git config --get interactive.diffFilter || echo ${PAGER:-less})'

zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview "$git_diff_preview"
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --color=always "$word"'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview 'git help "$word" | bat -p -l man --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview 'git show --color=always "$word"'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
    'case "$group" in' \
    '  "modified file") '"$git_diff_preview"' ;;' \
    '  "recent commit object name") git show --color=always "$word" ;;' \
    '  *) git log --color=always "$word" ;;' \
    'esac'

zstyle ':fzf-tab:complete:ollama:*' fzf-preview \
    'printf "\033[35m" && ' \
    'ollama list "$word" | tail -n +2 && ' \
    'printf "\033[0m\n" && ' \
    'ollama show "$word"'

# Install Starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# Aliases
source ~/.config/aliases

# Disable telemetry
export DO_NOT_TRACK=1
export DISABLE_TELEMETRY=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export HF_HUB_DISABLE_TELEMETRY=1