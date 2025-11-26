# https://wiki.archlinux.org/title/XDG_Base_Directory
# https://specifications.freedesktop.org/basedir-spec/latest/

set -x XDG_DATA_HOME "$HOME/.share"
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_STATE_HOME "$HOME/.local/state"
# set -x XDG_DATA_DIRS "/usr/share" "/usr/local/share"
set -x XDG_CONFIG_DIRS /etc/xdg
set -x XDG_CACHE_HOME "$HOME/.cache"
# set -x XDG_RUNTIME_DIR …

# https://www.freedesktop.org/wiki/Software/xdg-user-dirs/
set -x XDG_DESKTOP_DIR "$HOME/Desktop"
set -x XDG_DOWNLOAD_DIR "$HOME/Downloads"
set -x XDG_TEMPLATES_DIR "$HOME/Templates"
set -x XDG_PUBLICSHARE_DIR "$HOME/Public"
set -x XDG_DOCUMENTS_DIR "$HOME/Documents"
set -x XDG_MUSIC_DIR "$HOME/Music"
set -x XDG_PICTURES_DIR "$HOME/Pictures"
set -x XDG_VIDEOS_DIR "$HOME/Videos"

if test (uname) = Darwin
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

# bison

# if brew_ok
#     fish_add_path /opt/homebrew/opt/bison/bin
#     set -gx LDFLAGS -L/opt/homebrew/opt/bison/lib
# end

# clingo
# if command -v clingo >/dev/null 2>&1
#     set -gx CLINGO_LIBRARY_PATH "$HOMEBREW_PREFIX/opt/clingo/lib"
#     set -gx LD_LIBRARY_PATH "$LD_LIBRARY_PATH:$CLINGO_LIBRARY_PATH"
# end

# conan // https://docs.conan.io/2/reference/environment.html#environment-variables
# set -gx CONAN_HOME "$XDG_CONFIG_HOME/conan2"

# docker
set -gx DOCKER_CONFIG "$XDG_CONFIG_HOME/docker"

# dotnet
# fish_add_path "$HOME/.dotnet/tools"
# set -gx NUGET_PACKAGES "$XDG_CACHE_HOME/NuGetPackages"

# if brew_ok
#     set -gx DOTNET_ROOT "$HOMEBREW_PREFIX/opt/dotnet/libexec"
# end

# flex

# if brew_ok
#     fish_add_path /opt/homebrew/opt/flex/bin

#     set -gx LDFLAGS -L/opt/homebrew/opt/flex/lib
#     set -gx CPPFLAGS -I/opt/homebrew/opt/flex/include
# end

# hammerspoon
# defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

# hunspell
set -gx DICPATH "$XDG_CONFIG_HOME/hunspell/dictionaries"

# keras
set -gx KERAS_HOME "$XDG_DATA_HOME/keras"

# lean
set -gx ELAN_HOME "$XDG_DATA_HOME/elan"

# less
set -gx LESSHISTFILE "$XDG_STATE_HOME/less/history"

# man
set -x MANPAGER "nvim +Man!"

# npm / node
set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
fish_add_path "./node_modules/.bin"

# OCaml

set -gx OPAMROOT "$XDG_DATA_HOME/opam"

# This adds: the correct directories to the PATH, auto-completion for the opam binary
test -r '/Users/sparkes/.share/opam/opam-init/init.fish' && source '/Users/sparkes/.share/opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true


# python
set -gx PYTHONPYCACHEPREFIX "$XDG_CACHE_HOME/python_cache"
set -gx PYTHON_HISTORY "$XDG_CACHE_HOME/python/history"
set -gx IPYTHONDIR "$XDG_CACHE_HOME/ipython"
set -gx MPLCONFIGDIR "$XDG_CACHE_HOME/matplotlib"

# rust
source "$HOME/.cargo/env.fish"

# vcpkg
# set -gx VCPKG_ROOT "$XDG_DATA_HOME/vcpkg"
# fish_add_path "$VCPKG_ROOT"
# set -gx VCPKG_FORCE_SYSTEM_BINARIES 1

# etc

## https://fishshell.com/docs/current/faq.html#faq-history
function last_history_item; echo $history[1]; end
abbr -a !! --position anywhere --function last_history_item

# fzf
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'

# setup

if status is-interactive
    # Commands to run in interactive sessions can go here
end
starship init fish | source

set -x FZF_DEFAULT_OPTS_FILE $XDG_CONFIG_HOME/fzf/default_ops
fzf --fish | source

zoxide init fish | source

direnv hook fish | source

if command -q nix-your-shell
  nix-your-shell fish | source
end
