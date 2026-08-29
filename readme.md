# dotfiles

## Install packages

Choose the core package set or the full package set. The full bundle includes
the core, optional, and current-platform bundles, so these are alternatives:

```sh
# Small shared baseline.
brew bundle --file ~/dotfiles/shared/.config/brew/Brewfile.core

# Full package set for the current platform.
brew bundle --file ~/dotfiles/shared/.config/brew/Brewfile
```

On Ubuntu:

```sh
~/dotfiles/linux/.local/bin/install-apt-packages ~/dotfiles/shared/.config/apt/packages

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

brew bundle --file ~/dotfiles/shared/.config/brew/Brewfile
```

## Deploy configuration with Mise

Mise deploys configuration into `$HOME` and loads the shared and platform-specific environment.

```sh
mise trust ~/dotfiles/mise.toml
mise --cd ~/dotfiles bootstrap dotfiles apply
```

Use the personal overlay only where its local services are wanted:

```sh
mise --cd ~/dotfiles --env personal bootstrap dotfiles apply
```

Deployment is idempotent and uses individual symlinks, so a managed directory can also contain machine-local files.
Check the result or preview a change with:

```sh
mise --cd ~/dotfiles bootstrap dotfiles status
mise --cd ~/dotfiles bootstrap --only dotfiles --dry-run
```

After the first deployment, the linked `dotfiles-install` command applies the same dotfiles-only operation from any directory:

```sh
dotfiles-install
dotfiles-install --dry-run --verbose
```

Links reflect ordinary repository edits and pulls immediately; run deployment again only after paths have been added, removed, or moved.
Start a fresh shell after the first deployment so Mise activation is available.

For a repository update that may change the deployed path layout:

```sh
git -C ~/dotfiles pull
dotfiles-install
```

## Use the environment

Mise loads `mise.toml` and the matching `mise.macos.toml` or `mise.linux.toml` automatically.
It provides the shared variables, platform paths, and `HOMEBREW_BUNDLE_FILE`; after shell activation this works without a
`--file` argument:

```sh
brew bundle
```

`--env personal` selects the opt-in personal overlay and composes with the deployment commands above.

Keep machine-specific values in the untracked, highest-priority layer:

```text
~/.config/mise/config.local.toml
```

For example:

```toml
[env]
EDITOR = "nvim"

[env._]
path = ["/opt/llvm/bin"]
```

Other local configuration can coexist beside managed files:

```text
~/.config/git/config.local
~/.config/ghostty/config.local
```

## Use debugging tools

The package lists provide GDB and an LLVM LLDB adapter.
`~/.local/bin/lldb-dap` resolves Homebrew's keg-only LLVM installation and Ubuntu's versioned adapter names.

Pet uses the Python interpreter selected for the project, so install debugpy in that environment.
For a uv project:

```sh
uv add --dev debugpy
```

Synchronise Fish plugins when their declared set changes:

```sh
fish_plugins_sync
```

To use the configured Fish directly over SSH without changing the remote login shell:

```sh
ssh -t HOST '/home/linuxbrew/.linuxbrew/bin/fish -l'
```
