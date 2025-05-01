# Environment
source "${XDG_CONFIG_HOME:-~/.config}"/env

# Aliases
source "${XDG_CONFIG_HOME:-~/.config}"/aliases

# Functions
fpath=($fpath $ZDOTDIR/functions)

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

# Configure ollama completion
source $ZDOTDIR/plugins/ollama_zsh_completion/ollama_zsh_completion.plugin.zsh

# Configure zoxide
eval "$(zoxide init zsh --cmd j)"

# Configure fzf
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
case $FZF_DEFAULT_OPTS in
    *--tmux*) tmux_popup=--tmux-popup ;;
    *)        tmux_popup= ;;
esac

zstyle ':fzf-tab:complete:*:*' fzf-preview \
    'preview --header '"$tmux_popup"' ${(Q)realpath} 2> /dev/null || ' \
    'echo "No preview for \033[32m$word\033[0m"'

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
    '(out=$(tldr --color always "$word") 2> /dev/null && echo "$out") || ' \
    '(out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2> /dev/null && echo "$out") || ' \
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

# Configure Starship
export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-~/.config}"/starship/starship.toml
eval "$(starship init zsh)"