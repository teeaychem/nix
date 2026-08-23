# dotfiles

Mise deploys the shared configuration and platform overlay into `$HOME`:

- `common`: configuration and commands shared by all systems
- `darwin`: macOS configuration and commands
- `linux`: Linux configuration


## Utils

### Fish

``` sh
fish_plugins_sync
```

## Install

Clone the repository, install the platform package set, then apply the
configuration:

```sh
git clone ssh://git@codeberg.org/teeaychem/dot.git ~/dotfiles
cd ~/dotfiles
```

On macOS, use the core Homebrew bundle:

```sh
brew bundle --file common/.config/brew/Brewfile.core
```

On Ubuntu, install Homebrew's bootstrap dependencies:

```sh
./linux/.local/bin/install-apt-packages common/.config/apt/packages
```

Install Homebrew at its standard Linux prefix, then load it into the current
shell:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

Install the shared and Linux-specific Homebrew packages:

```sh
brew bundle --file common/.config/brew/Brewfile
```

Then apply the Mise-managed dotfiles:

```sh
mise --cd ~/dotfiles bootstrap --only dotfiles
```

On the personal Mac, include the personal services configuration:

```sh
mise --cd ~/dotfiles --env personal bootstrap --only dotfiles
```

Start a fresh shell after linking the configuration.

To use that Fish directly over SSH, without changing the remote login shell:

```sh
ssh -t HOST '/home/linuxbrew/.linuxbrew/bin/fish -l'
```

After the first install, the wrapper command is available from any directory:

```sh
dotfiles-install
```

Preview changes without creating links:

```sh
dotfiles-install --dry-run --verbose
```

Mise deploys individual symlinks, allowing machine-local files to coexist in
the same directories.

After applying the dotfiles, the command is available as
`install-apt-packages PACKAGE_FILE`.

Mise provides the shared and platform-specific environment, including
`HOMEBREW_BUNDLE_FILE`, after shell activation.

For a fuller Homebrew install, use `common/.config/brew/Brewfile`, which
includes the shared core bundle, shared optional bundle, and the current
platform bundle.

## Debugging

The Homebrew and Ubuntu package lists install GDB and LLVM's LLDB adapter.
`~/.local/bin/lldb-dap` resolves Homebrew's keg-only LLVM installation and
Ubuntu's versioned adapter names.

Pet runs debugpy with the Python interpreter selected for the current project,
so debugpy must also be present in that environment. For uv projects:

```sh
uv add --dev debugpy
```

## Machine-local files

Files such as the following should remain machine-local:

```text
~/.config/git/config.local
~/.config/ghostty/config.local
~/.config/mise/config.local.toml
```

## Update

Existing links follow repository updates immediately. Run the installer after
files are added, removed, or moved:

```sh
cd ~/dotfiles
git pull
dotfiles-install
```

## Audit

Generate `config.ignore` from the preserved `.gitignore` patterns:

```sh
dotfiles-config-ignore
```

List files under `$XDG_CONFIG_HOME` that are neither matched by
`config.ignore` nor symlinks managed by this repository:

```sh
dotfiles-config-audit
```

The result is a review list, not an instruction to move every reported file.
It can include current machine-local files whose long-term placement remains
undecided. Update `.gitignore` and regenerate after deciding a path should
remain local or is generated state.

## Environment configuration

Mise provides shared, platform, and machine-local environment configuration:

```text
~/dotfiles/mise/config.toml
~/dotfiles/mise/config.macos.toml or config.linux.toml
~/.config/mise/config.local.toml
```

Mise loads the shared configuration and matching platform overlay automatically.
The optional, untracked `config.local.toml` has the highest priority.

Use `[env]` for baseline scalar values and `env._.path` for path-like
variables:

```toml
[env]
EDITOR = "nvim"

[env._]
path = ["/opt/llvm/bin"]
```

`XDG_CONFIG_HOME`, `XDG_STATE_HOME`, `XDG_DATA_HOME`, and `XDG_CACHE_HOME`
remain shell bootstrap variables because they are needed before Mise is
initialized. Known unexported variable names used for completion remain in
`~/.config/shell/vars/base.vars`.
