# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Initialize history
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

# Shell options
setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep

# Initialize completion system
zstyle :compinstall filename '~/.zshrc'
autoload -Uz compinit
compinit

# Load prezto
source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

# Load Powerlevel10k theme
source "${ZDOTDIR:-$HOME}/.p10k.zsh"

# Load custom configurations
source "${ZDOTDIR:-$HOME}/.dotfiles/zsh/aliases.zsh"
source "${ZDOTDIR:-$HOME}/.dotfiles/zsh/functions.zsh"
source "${ZDOTDIR:-$HOME}/.dotfiles/zsh/keybindings.zsh"
source "${ZDOTDIR:-$HOME}/.dotfiles/zsh/git.zsh"
source "${ZDOTDIR:-$HOME}/.dotfiles/zsh/docker.zsh"

# Initialize zoxide
eval "$(zoxide init zsh)"