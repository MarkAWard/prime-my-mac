# prime-my-mac

Automate local, new Mac setup and configuration.

## Installation

**Virgin Mac, one-shot:**

```bash
curl -fsSL https://raw.githubusercontent.com/MarkAWard/prime-my-mac/master/bootstrap.sh | bash
```

`bootstrap.sh` installs Homebrew (which pulls in Xcode Command Line Tools as a side effect), clones this repo into `~/.prime-my-mac`, and hands off to `./install.sh --all`.

**Already have a clone?** Invoke `install.sh` directly with one or more flags:

```bash
./install.sh --all                        # everything
./install.sh --python --brew --cask       # subset
./install.sh --dot-files                  # just copy dotfiles
```

Running with no flags prints usage. A background `sudo` keep-alive runs for the duration of the install, so expect a password prompt up front.

## Flags

| Flag | What it does |
|---|---|
| `--all` | Run everything below, in a sensible order |
| `--python` | `pyenv` + Python versions (3.11–3.14) + pip packages (ruff, black, mypy, ipython, flake8) |
| `--node` | `nvm` + Node LTS as default |
| `--brew` | Homebrew formulae (`libs/data.sh brew_pkgs`) |
| `--cask` | Homebrew casks (`libs/data.sh cask_pkgs`) |
| `--fonts` | Homebrew cask fonts (Nerd Fonts — `libs/data.sh cask_fonts`) |
| `--github` | Interactive `gh auth login` + `gh auth setup-git` (wires gh as git's HTTPS credential helper) |
| `--osx` | `defaults write` tweaks across Dock, Finder, input devices, etc. |
| `--app-configs` | Per-app configs (VS Code + Cursor shared settings, iTerm2 bookmark tweaks, Activity Monitor, Terminal.app) |
| `--prezto` | Clone [prezto](https://github.com/sorin-ionescu/prezto), chsh to zsh |
| `--bash-it` | Clone [bash-it](https://github.com/Bash-it/bash-it), chsh to bash |
| `--dot-files` | Stage dotfiles at `~/.dotfiles/` and git configs at `~/.config/git/` |

## Layout

- `bootstrap.sh` — virgin-Mac entry point (curlable)
- `install.sh` — flag dispatcher; sources everything in `libs/`
- `libs/data.sh` — data only (package lists, font lists, dock entries, VS Code extensions, iTerm2 profile settings)
- `libs/main.sh` — `install_*` functions + the `status_msg` helper used everywhere
- `libs/osx.sh` — `*_tweaks` functions, each a batch of `defaults write` calls
- `libs/apps.sh` — per-app config (vscode_config, iterm2_config, etc.)
- `files/dotfiles/` — shell configs, staged to `~/.dotfiles/` then symlinked into `$HOME`. `.zshrc` sources `zshrc.d/*.zsh` (zsh-only) and `rc.d/*.sh` (shell-agnostic); the bash side does the same through `bashrc.d/*.bash`.
- `files/git/` — git config, staged to `~/.config/git/` (XDG-standard). Includes `.gitconfig`, `.gitconfig.user`, and `.gitignore_global`.
- `files/vscode_settings.json` — shared settings file deployed to both VS Code and Cursor

## Shell

Primary shell is zsh via prezto, `agnoster` theme. Prompt segments and custom helpers live in [files/dotfiles/zshrc.d/prompt.zsh](files/dotfiles/zshrc.d/prompt.zsh).

Bash dotfiles (`.bashrc`, `.bash_profile`, `bashrc.d/*`) are still staged in case of fallback, and `--bash-it` installs bash-it — but prezto is the primary environment.

## Conventions

- Data lives in `libs/data.sh`; logic lives elsewhere. Don't inline package lists into `main.sh`.
- Every install/tweak function logs via `status_msg` (colored `[Y]/[N]` lines plus a macOS notification).
- Cask packages can carry a `:l` suffix for laptop-only entries (checked against `IS_LAPTOP` in `libs/main.sh`, set from `sysctl hw.model`).
- `install_dotfiles` does `rm -rf ~/.dotfiles` before copying — local edits under `~/.dotfiles` are destroyed on each run. Edit in the repo and re-run `--dot-files`.
