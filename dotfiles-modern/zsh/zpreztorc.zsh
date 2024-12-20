# Color output (auto set to 'no' on dumb terminals).
zstyle ':prezto:*:*' color 'yes'

# Set the Prezto modules to load.
# The order matters.
zstyle ':prezto:load' pmodule \
  'environment' \
  'terminal' \
  'editor' \
  'history' \
  'directory' \
  'utility' \
  'completion' \
  'git'

# Set the key mapping style to 'emacs' or 'vi'.
zstyle ':prezto:module:editor' key-bindings 'vi'

# Git status configuration
# Disable submodule checking as Powerlevel10k handles this efficiently
zstyle ':prezto:module:git:status:ignore' submodules 'all'

# Directory navigation
zstyle ':prezto:module:utility:ls' color 'yes'
zstyle ':prezto:module:utility:diff' color 'yes'
zstyle ':prezto:module:utility:wdiff' color 'yes'
zstyle ':prezto:module:utility:make' color 'yes'

# Ensure proper terminal type for WezTerm
zstyle ':prezto:module:terminal' auto-title 'yes'
zstyle ':prezto:module:terminal:window-title' format '%n@%m: %s'
zstyle ':prezto:module:terminal:tab-title' format '%m: %s'

# History configuration
zstyle ':prezto:module:history' histfile "${ZDOTDIR:-$HOME}/.zhistory"
zstyle ':prezto:module:history' histsize 10000
zstyle ':prezto:module:history' savehist 10000

# Directory configuration
zstyle ':prezto:module:directory' auto-cd 'yes'
zstyle ':prezto:module:directory' auto-pushd 'yes'
zstyle ':prezto:module:directory' pushd-ignore-dups 'yes'

# Remove redundant modules and iTerm2 integration
# Removed: 'spectrum', 'prompt', 'fasd', 'tmux:iterm'
# Removed: duplicate module loads
# Removed: tmux auto-start (handled by WezTerm)