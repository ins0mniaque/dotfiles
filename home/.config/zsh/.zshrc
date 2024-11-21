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

# Configure zoxide
eval "$(zoxide init zsh --cmd j)"

# Configure fzf
export FZF_DEFAULT_COMMAND="fd --strip-cwd-prefix --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND --type file"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type directory"

if [ "$COLORTERM" = truecolor ] || [ "$COLORTERM" = 24bit ]; then
    export FZF_COLORS='--color=bg+:#293739,bg:#1B1D1E,border:#808080,spinner:#E6DB74,hl:#7E8E91,fg:#F8F8F2,header:#7E8E91,info:#A6E22E,pointer:#A6E22E,marker:#F92672,fg+:#F8F8F2,prompt:#F92672,hl+:#F92672'
else
    export FZF_COLORS=''
fi

export FZF_DEFAULT_OPTS="
  --height 40% --tmux 80%
  --layout=default
  --info=inline-right
  --prompt='❯ ' --pointer='❯' --marker='⚫'
  --preview-window 'border-left'
  --bind 'ctrl-p:change-preview-window(down,border-top|hidden|border-left)'
  --bind bspace:backward-delete-char/eof
  $FZF_COLORS"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'preview --header {}'"
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'preview --header {}'"

_fzf_compgen_path() { fd --hidden --follow --exclude ".git" . "$1" }
_fzf_compgen_dir() { fd --type d --hidden --follow --exclude ".git" . "$1" }
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    export|unset) fzf --preview "eval 'echo \$'{}"    "$@" ;;
    ssh)          fzf --preview 'dig {}'              "$@" ;;
    *)            fzf --preview 'preview --header {}' "$@" ;;
  esac
}

source <(fzf --zsh)

bindkey '^F' fzf-file-widget
bindkey '^G' fzf-cd-widget
bindkey '^H' fzf-history-widget

# Configure fzf-tab
# TODO: Automatically run build-fzf-tab-module on first install
source $ZDOTDIR/plugins/fzf-tab/fzf-tab.plugin.zsh

zstyle ':completion:*' fzf-search-display true
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' menu no
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -ww"
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'

zstyle ':fzf-tab:*' switch-group F1 F2
zstyle ':fzf-tab:*' continuous-trigger 'tab'
zstyle ':fzf-tab:*' fzf-flags ${(Q)${(Z:nC:)FZF_DEFAULT_OPTS}}

zstyle ':fzf-tab:complete:*:*' fzf-preview 'preview --header ${(Q)realpath}'
zstyle ':fzf-tab:complete:*:options' fzf-preview 
zstyle ':fzf-tab:complete:*:argument-1' fzf-preview
zstyle ':fzf-tab:complete:(kill|ps):*' fzf-preview
zstyle ':fzf-tab:complete:ssh:*' fzf-preview 'dig +short $word'
zstyle ':fzf-tab:complete:brew-(install|uninstall|search|info):*-argument-rest' fzf-preview 'brew info $word'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

zstyle ':fzf-tab:complete:(-parameter-|-brace-parameter-|export|unset|expand|typeset|declare|local):*' fzf-preview 'echo ${(P)word}'
zstyle ':fzf-tab:complete:man:argument-1' fzf-preview 'man "$word"'
zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color always "$word"'
zstyle ':fzf-tab:complete:-command-:*' fzf-preview \
 '(out=$(tldr --color always "$word") 2>/dev/null && echo $out) ||
  (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) ||
  (out=$(which "$word") && echo $out) ||
  echo "${(P)word}"'

zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview 'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview 'git show --color=always $word'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
 'case "$group" in
    "modified file") git diff $word ;;
    "recent commit object name") git show --color=always $word ;;
    *) git log --color=always $word ;;
  esac'

# Configure auto-suggestions / syntax highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Install Starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# Aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ls='eza --all'
alias ll='eza --all --long --git --group-directories-first'