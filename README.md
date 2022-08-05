# prime-my-mac
Automate local, new mac setup and configuration

# Installation:
**To bootstrap, on first install:**
```bash
curl -fsSL https://raw.githubusercontent.com/ifarfan/prime-my-mac/master/bootstrap.sh | bash
```

# Pre-requisites:
N.O.N.E.  A.T.   A.L.L.

# What's going on here?!?
The automated installation pretty much boils down to:

- Install `Homebrew` package manager
- Install `python`
    - Use `brew` to install `pyenv`
    - Use `pyenv` to install multiple python3 minor versions, setting 3.9.x as default
    - `pip` install commonly used packages to the global python version
        - awscli, black, boto3, flake8...
    - `brew` install `pyenv-virtualenv`
- Install `brew` packages
    - bash completion, colors, emacs, mac utils, cli tools, ...
- Tap `homebrew/cask` and install Desktop applications
    - 1password, dbeaver, docker, iterm2, chrome, rectangle, VS code, ...
- Tap `homebrew/cask-fonts` and install a bunch of fonts
- Setting personalized tweaks to some MacOS + GUI apps
    - Running obscure `defaults write` commands that control the MacOS look and feel
    - Importing some settings/prefences for things like VS Code, iterm2, chrome, ...
- Install `bash-it` for bash things and `prezto` for zsh things, change shell to `zsh`
- Copying over a bunch of `.` (dot) + other miscellaneous files
- And a fair amount of convoluted `Bash` to glue it all together


Some things to note:

- The actual list of apps + utilities to install are under [libs/data.sh](libs/data.sh)
- Mac tweaks are all under [libs/osx.sh](libs/osx.sh)
- Specific app tweaks are under [libs/apps.sh](libs/apps.sh)
- My shell of choice is `prezto` (*zsh*), thus my `.` files reflect that
    - I use `agnoster` theme, prompt customized in [files/dotfiles/zshrc.d/prompt.zsh](files/dotfiles/zshrc.d/prompt.zsh), with `emacs` key bindings
- I do the code things with `VSCode` and `iterm2`, and a bunch of aliases and git configin
