### `~/.dotfiles`

My setup for OS X, tmux, zsh, git, VS Code, JavaScript

Copy this into `~/dotfiles`. If it's not a brand new machine you probably already have some of the files/folders. You can replace them or merge them together.

```sh
git clone --recursive git@github.com:danielzurawski/dotfiles.git ~/.dotfiles
```

#### Install script

**At your own risk**: Review `install.sh`, edit to your requirements, and execute it. It will install dependencies via Homebrew, load iterm settings, symlink various dotfiles to your home directory, and configure tmux, VS Code etc.
