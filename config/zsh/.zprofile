if [[ $(uname) == "Darwin" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

#clingo
if command -v clingo; then
    if [[ $(uname) == "Darwin" ]]; then
        export CLINGO_LIBRARY_PATH=/opt/homebrew/opt/clingo/lib
        export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CLINGO_LIBRARY_PATH
    fi
fi

# docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker

# dotnet
if [[ $(uname) == "Darwin" ]]; then
    export DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"
    export PATH="$PATH:$HOME/.dotnet/tools"

    export NUGET_PACKAGES="$XDG_CACHE_HOME"/NuGetPackages
fi

# hammerspoon
# defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

# hunspell
export DICPATH="$XDG_CONFIG_HOME/hunspell/dictionaries"

# lean
export ELAN_HOME=$XDG_DATA_HOME/elan

# less
export LESSHISTFILE="$XDG_STATE_HOME"/less/history

# llvm / clang, etc.
if [[ $(uname) == "Darwin" ]]; then
    export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
    LDFLAGS="-L/opt/homebrew/opt/llvm/lib/unwind -lunwind"
    LDFLAGS="-L/opt/homebrew/opt/llvm/lib/c++ -L/opt/homebrew/opt/llvm/lib/unwind -lunwind"
fi

#m4
if [[ $(uname) == "Darwin" ]]; then
    export PATH="/opt/homebrew/opt/m4/bin:$PATH"
fi

# man
alias man='man -pager="less"'

# npm / node
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PATH=$PATH:./node_modules/.bin

# python
export PYTHONPYCACHEPREFIX=$XDG_CACHE_HOME/python_cache
export PYTHON_HISTORY=$XDG_CACHE_HOME/python/history
export IPYTHONDIR=$XDG_CACHE_HOME/ipython
export MPLCONFIGDIR=$XDG_CACHE_HOME/matplotlib

export KERAS_HOME=$XDG_DATA_HOME/keras

# racket
# export RACKET=/Applications/Racket\ v8.9/bin

# rust
export CARGO_HOME=$XDG_DATA_HOME/cargo
export RUSTUP_HOME=$XDG_DATA_HOME/rustup
export RUSTBIN="$CARGO_HOME/bin"
export PATH="$PATH:$RUSTBIN"

# vcpkg

export VCPKG_ROOT=$XDG_DATA_HOME/vcpkg
export PATH="$VCPKG_ROOT:$PATH"
export VCPKG_FORCE_SYSTEM_BINARIES=1

if [ -f ~/.config/zsh/.profile_local ]; then
    source ~/.config/zsh/.profile_local
fi


# fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
alias fzfp=$'fzf --style full --preview \'fzf-preview.sh {}\' --bind \'focus:transform-header:file --brief {}\''

