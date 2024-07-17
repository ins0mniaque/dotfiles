# Configure zsh autocompletion cache to XDG specification
autoload -U compinit
compinit -d "$ZCACHEDIR/zcompdump-$ZSH_VERSION"
zstyle ':completion:*' cache-path "$ZCACHEDIR"/zcompcache

fpath=($fpath $ZDOTDIR/func)

# Configure applications to XDG specification
source $HOME/.config/xdg/configure

# Configure keyboard
source $ZDOTDIR/plugins/zsh-modern-keybindings/zsh-modern-keybindings.zsh

# Configure Jump
eval "$(jump shell)"

# Configure less
export LESS="FRX --mouse"

# Configure fzf
RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "

export FZF_FILES_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_DIRECTORIES_COMMAND="fd --type d --hidden --follow --exclude .git"
export FZF_REGEX_COMMAND="fzf-rg"
export FZF_DEFAULT_COMMAND="$FZF_FILES_COMMAND"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_F_COMMAND="$FZF_REGEX_COMMAND"
export FZF_CTRL_O_COMMAND="$FZF_REGEX_COMMAND '%q:%s:%s'"

# fzf-rg "format" "initial query"
# format: Format for output; defaults to quoted filename only
#         e.g. default: "%q%.s%.s", nano/micro "%q +%s,%s", emacs +LINE:COLUMN "%q +%s:%s", vim "%q +%s%.s"
fzf-rg() {
  # TODO: Non-rg version? i.e. command find . -type f -exec grep {q} {} \;
  local RG="rg --column --line-number --no-heading --color=always --smart-case"
  local selected=("${(@f)$( \
    FZF_DEFAULT_COMMAND="$RG $(printf %q "$2")" \
      fzf --ansi \
          --multi \
          --color "hl:-1:underline,hl+:-1:underline:reverse" \
          --disabled --query "$2" \
          --bind "change:reload:sleep 0.25; $RG {q} || true" \
          --bind "alt-enter:unbind(change,alt-enter)+change-prompt(❯ )+enable-search+clear-query" \
          --prompt '(.*) ' \
  )}")

  [ -n "$selected" ] || return 1

  for entry ("$selected[@]")
  do
    parts=(${(s/:/)entry})
    printf "${1-%q%.s%.s} " $parts[1] $parts[2] $parts[3]
  done
}

FZF_COLORS="--color=bg+:#293739,bg:#1B1D1E,border:#808080,spinner:#E6DB74,hl:#7E8E91,fg:#F8F8F2,header:#7E8E91,info:#A6E22E,pointer:#A6E22E,marker:#F92672,fg+:#F8F8F2,prompt:#F92672,hl+:#F92672"

check_terminal_size () {
    if [[ "$LINES $COLUMNS" != "$previous_lines $previous_columns" ]]; then
        set_fzf_default_opts
    fi
    previous_lines=$LINES
    previous_columns=$COLUMNS
}

function set_fzf_default_opts() {
  width=$COLUMNS
  if [ -n "$TMUX" ]; then
    width=$(tmux display -p '#{window_width}')
  fi
  # Adjust for small size
  popup_width=$(($width * 2 / 3))

  FZF_OPTS="\
  --multi \
  --preview-window ':hidden,~1,right,$popup_width,border-left' \
  --bind 'ctrl-d:reload($FZF_DIRECTORIES_COMMAND),ctrl-f:reload($FZF_FILES_COMMAND)' \
  --bind bspace:backward-delete-char/eof \
  --bind 'ctrl-p:toggle-preview+change-preview(preview --header {})' \
  --bind 'alt-l:toggle-preview' \
  --bind 'alt-y:execute:pbcopy {}' \
  --bind 'ctrl-t:replace-query' \
  --bind 'ctrl-s:toggle-sort' \
  --bind 'ctrl-a:select-all' \
  --bind 'f12:execute-silent:(subl -b {})' \
  --prompt='❯ ' --pointer='❯' --marker='⚫'"
  export FZF_DEFAULT_OPTS="$FZF_COLORS $FZF_OPTS"

  zstyle ':fzf-tab:*' fzf-flags --preview-window "~2,right,$popup_width,border-left" 
  #--prompt='❯ ' --pointer='❯' --marker='⚫'
  zstyle ':fzf-tab:complete:*:*' popup-pad $(( popup_width + 2 )) 240
  zstyle ':fzf-tab:complete:*' fzf-bindings 'tab:toggle+down,shift-tab:toggle+up'
  zstyle ':fzf-tab:*' continuous-trigger '#'

  #zstyle ':fzf-tab:*' fzf-flags --preview-window "~1,right,$popup_width,border-left" --bind 'alt-l:toggle-preview'
  #zstyle ':fzf-tab:complete:*:*' popup-pad $(( popup_width + 2 )) 120
  #zstyle ':fzf-tab:complete:*:*' popup-size 0 120
}

set_fzf_default_opts
trap 'check_terminal_size' WINCH

# TODO: Automatically run build-fzf-tab-module on first install
source $ZDOTDIR/plugins/fzf-tab/fzf-tab.plugin.zsh

# HACK: Hide cursor when fzf is running inside a tmux popup
function tmux() {
    args=($@)
    for ((i = 2; i <= $#args; i++)); do
        if [[ $args[((i - 1))] == '-E' && $args[i] =~ 'fzf' ]]; then
            args[i]="tput civis >/dev/tty 2>/dev/null; ${args[i]}; tput cnorm >/dev/tty 2>/dev/null"
        fi
    done

    set -- ${args[@]}
    command tmux "$@"
}

fzf-find-widget() {
  LBUFFER="${LBUFFER}$(eval "${FZF_CTRL_F_COMMAND:-fzf-rg}")"
  local ret=$?
  zle reset-prompt
  return $ret
}

# TODO: Fix open on cancel...
fzf-open-widget() {
  ${EDITOR:-micro} $(eval "${FZF_CTRL_O_COMMAND:-fzf-rg '%q:%s:%s'}")
}

zle     -N   fzf-find-widget
bindkey '^F' fzf-find-widget
zle     -N   fzf-open-widget
bindkey '^O' fzf-open-widget

# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"




# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

#zstyle ':fzf-tab:complete:*:files' fzf-preview 'preview ${(Q)realpath}'
#zstyle ':fzf-tab:complete:*:files' popup-pad 40 0

# preview directory's content with eza when completing cd
#zstyle ':fzf-tab:complete:*:directories' fzf-preview 'eza -1 --color=always ${(Q)realpath}'
#zstyle ':fzf-tab:complete:*:directories' popup-pad 40 0

#zstyle ':fzf-tab:complete:*:hosts' fzf-preview 'dig {}'
#zstyle ':fzf-tab:complete:*:hosts' popup-pad 40 0

#zstyle ':fzf-tab:complete:*:parameters' fzf-preview 'echo lol'
#zstyle ':fzf-tab:complete:*:parameters' popup-pad 40 0

zstyle ':fzf-tab:complete:*:*' fzf-preview '
desc=$(echo "$desc" | sed -e "s/[^a-zA-Z[:space:]]//g" -e "s/^[[:space:]]*//")
group=$(echo "$group" | sed -e "s/[^a-zA-Z[:space:]]//g" -e "s/^[[:space:]]*//")
[ -n $realpath ] && preview --header ${(Q)realpath}
[ $group = "parameter" ] && echo $word=$(eval "echo \$"$word)
[ $group = "manual page" ] && man $word | bat --style=numbers --color=always --wrap auto --language man
[ $group = "remote host name" ] && dig +noall +answer +stats ${(Q)word} | sed -e "s/;; Query/\nQuery/g" -e "s/;; //g"
'
# zstyle ':fzf-tab:*' fzf-flags --preview-window '~1,right,40,border-left'
# zstyle ':fzf-tab:complete:*:*' popup-pad 42 0

# zstyle ':fzf-tab:complete:*:*' extra-opts --preview=$fzf_tab_preview_init'
# echo word: $word
# echo description: $desc
# echo group: $group
# if (( $+ctxt[isfile] )); then
#   echo path: $realpath
# fi
# '

# man support?
# zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview 'man $word'

# it is an example. you can change it
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
	'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
	'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
	'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	'case "$group" in
	"commit tag") git show --color=always $word ;;
	*) git show --color=always $word | delta ;;
	esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	'case "$group" in
	"modified file") git diff $word | delta ;;
	"recent commit object name") git show --color=always $word | delta ;;
	*) git log --color=always $word ;;
	esac'

# give a preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' 'fzf-preview \
  [[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
# zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

# switch group using F1 and F2
# TODO: Change shortcut
zstyle ':fzf-tab:*' switch-group F1 F2


# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

[ -n "$TMUX" ] && zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# [ -n "$TMUX" ] && zstyle ':fzf-tab:*' fzf-command fzf-tmux

# tm - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
# `tm` will allow you to select your tmux session via fzf.
# `tm irc` will attach to the irc session (if it exists), else it will create it.

tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

# fh - repeat history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# Configure auto-suggestions / syntax highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Install Starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# Aliases
alias ll='eza -al --group-directories-first'
alias ls='eza -alF --color=always --sort=size | grep -v /'