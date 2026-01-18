# # # maybe someday
# https://getantidote.github.io/usage

# options

# # misc

# # history

HISTORY_IGNORE="(ls|cd|pwd)*"

# # # no duplication
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FCNTL_LOCK

setopt EXTENDED_HISTORY # additional info

# # # corrections
# setopt CORRECT
# setopt CORRECT_ALL

# # # keys

set -o emacs

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
autoload select-word-style
select-word-style normal

bindkey '^I'   complete-word       # tab          | complete
bindkey '^[[Z' autosuggest-accept  # shift + tab  | autosuggest

bindkey "\e\e[D" backward-word  # | option + <-
bindkey "^[[1;5D" backward-word # | ctl + <-
bindkey "\e\e[C" forward-word   # | option + ->
bindkey "^[[1;5C" forward-word  # | ctl + ->

# # # python
# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/python/python.plugin.zsh
alias py='python3'
alias py3='python3'

alias pyfind='find . -name "*.py"'
alias pygrep='grep -nr --include="*.py"'

function pyclean() {
  find "${@:-.}" -type f -name "*.py[co]" -delete
  find "${@:-.}" -type d -name "__pycache__" -delete
  find "${@:-.}" -depth -type d -name ".mypy_cache" -exec rm -r "{}" +
  find "${@:-.}" -depth -type d -name ".pytest_cache" -exec rm -r "{}" +
}

# # # macos
function rmdsstore() {
  find "${@:-.}" -type f -name .DS_Store -delete
}

# # # completions

# compinstall
# https://github.com/zsh-users/zsh-completions

# zstyle ':completion:*' completer _complete _match _approximate
# zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'l:|=* r:|=*'
# zstyle ':completion:*:functions' ignored-patterns '_*'
# zstyle :compinstall filename '~/.config/zsh/.zshrc'

# if [[ $(uname) == "Darwin" ]]; then
#     if type brew &>/dev/null; then
#         FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

#         autoload -Uz compinit
#         compinit -u
#     fi
# fi


autoload -U compinit && compinit
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)


# Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting to load these completions, you may need to run these commands:
# chmod go-w '/opt/homebrew/share'
# chmod -R go-w '/opt/homebrew/share/zsh'


# # # autosuggestions

# https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
# if [[ $(uname) == "Darwin" ]]; then
#     source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# fi

eval "$(starship init zsh)"

# fzf
source <(fzf --zsh)

# zoxide
eval "$(zoxide init zsh)"
