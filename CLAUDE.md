# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal macOS bootstrap: a shell-only installer that primes a fresh Mac (Homebrew, pyenv, brew/cask packages, macOS `defaults write` tweaks, app configs, prezto + bash-it, dotfiles). No build system, no test suite, no linter — everything is bash/zsh.

## Running the installer

`bootstrap.sh` is the one-shot entry for a virgin machine (curled from GitHub). On a cloned checkout, invoke `install.sh` directly with one or more flags:

```bash
./install.sh --all                        # everything
./install.sh --python --brew --cask       # subset
./install.sh --dot-files                  # copy files/dotfiles/ → ~/.dotfiles and symlink
./install.sh --osx                        # run all defaults-write tweaks
./install.sh --app-configs                # per-app plist/defaults tweaks
```

Flags are defined in `install.sh` and map to functions in `libs/`. Running with no flags prints usage and exits. The installer calls `sudo -v` up front and keeps it alive in a background loop — expect a password prompt.

## Architecture

**`install.sh` sources every file in `libs/` unconditionally**, then dispatches based on `FG_*` flags. This means:

- Any new function added to a file in `libs/` is immediately available in the installer's scope.
- `libs/data.sh` is data-only — arrays like `brew_pkgs`, `cask_pkgs`, `cask_fonts`, `pip_pkgs`, `pyenv_versions`, `dock_apps`. Edit here to change what gets installed.
- `libs/main.sh` holds the core `install_*` functions (homebrew, python, brew, cask, fonts, prezto, bash-it, dotfiles) and the `status_msg` helper used everywhere for colored + `osascript`-notification logging.
- `libs/osx.sh` is a collection of `*_tweaks` functions (dock, finder, screen, ssd, energy, security…), each a batch of `defaults write` calls.
- `libs/apps.sh` is per-app config (`vscode_config`, `iterm2_config`, `activity_monitor_config`, …) — these mostly write to plists or copy seed files from `files/`.

**Packages/extensions can carry attributes** via a `:` suffix. If you add a new attribute letter, wire it into the corresponding install function.

- `cask_pkgs` — `:l` (laptop-only), honored in `install_brew_cask` via `$IS_LAPTOP` (set in `libs/main.sh` from `sysctl hw.model`).
- `vscode_extensions` — `:v` (VS Code only, skipped for Cursor) and `:c` (Cursor only, skipped for VS Code), parsed in `vscode_config` in `libs/apps.sh`. Use `:v` when an extension isn't on OpenVSX or reliably fails Cursor's cert chain; use `:c` when something only exists on the OpenVSX fork.

`install_bash_it` and `install_prezto` both install their frameworks, but only `install_prezto` runs `chsh` (to `/bin/zsh`). Bash stays available with its framework loaded when invoked explicitly; users who want bash as the login shell run `chsh -s /bin/bash` themselves.

## Dotfiles layout

`files/dotfiles/` is copied to `~/.dotfiles` and every `.`-prefixed entry is symlinked into `$HOME`. The shell config is modular:

- `.zshrc` sources prezto first, then every `*.zsh` in `~/.dotfiles/zshrc.d/`, then every `*.sh` in `~/.dotfiles/rc.d/`.
- `rc.d/` is shell-agnostic (aliases, functions, colors, grc, gnuutils) — sourced by both bash and zsh.
- `zshrc.d/` is zsh-only (prompt segments, aws-plugin, kube-context, direnv, history).

Prompt uses prezto's agnoster theme with custom segments defined in `zshrc.d/prompt.zsh` — `AGNOSTER_PROMPT_SEGMENTS` controls order. Adding a new segment means defining a `prompt_<name>` function and listing it there. `aws-plugin.zsh` adds an `RPROMPT` entry that turns red for `*-prod`/`*production*` profiles; `kube-context.zsh` follows the same pattern but is gated on `SHOW_KUBE_PROMPT=true`.

When installing dotfiles, `install_dotfiles` does `rm -rf ~/.dotfiles` before copying — local edits under `~/.dotfiles` are destroyed on every run. Edit in the repo and re-run `--dot-files`.

## Conventions

- Every install/tweak function logs via `status_msg` (colored `[Y]/[N]` lines plus a macOS notification). Match this pattern in new functions.
- Data lives in `libs/data.sh`; logic lives elsewhere. Don't inline package lists into `main.sh`.
- `libs/main.sh` sets `HOMEBREW_NO_AUTO_UPDATE=1` and `HOMEBREW_NO_ANALYTICS=1` — don't undo these in install functions.
- `.zshrc` pre-loads pyenv, but `prompt_pyenv_conda` reads `$PYENV_VERSION` directly instead of shelling out to `pyenv version-name` (the pyenv call is the slow fallback). Keep that fast path when touching the prompt.
