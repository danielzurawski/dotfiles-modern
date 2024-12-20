HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep

zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit

# source zpresto
source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
# source the blox prompt + customizations
source "${ZDOTDIR:-$HOME}/.dotfiles/zsh/prompt.zsh"
# https://github.com/zsh-users/zsh-autosuggestions
source "${ZDOTDIR:-$HOME}/.dotfiles/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
# source nvm as a zsh plugin (https://github.com/lukechilds/zsh-nvm)
source "${ZDOTDIR:-$HOME}/.dotfiles/zsh/zsh-nvm/zsh-nvm.plugin.zsh"

# custom config
source "${ZDOTDIR:-$HOME}/.dotfiles/zsh/aliases.zsh"
source "${ZDOTDIR:-$HOME}/.dotfiles/zsh/functions.zsh"
source "${ZDOTDIR:-$HOME}/.dotfiles/zsh/keybindings.zsh"
source "${ZDOTDIR:-$HOME}/.dotfiles/zsh/git.zsh"
source "${ZDOTDIR:-$HOME}/.dotfiles/zsh/docker.zsh"
