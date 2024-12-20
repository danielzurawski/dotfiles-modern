# ask for password upfront
sudo -v

# HOMEBREW

read -p "
Do you want to install command line and GUI apps with Homebrew?
[y/N]: " -r Install_Apps
Install_Apps=${Install_Apps:-n}
if [[ "$Install_Apps" =~ ^(y|Y)$ ]]; then
  echo -e "\033[1m\033[34m==> Installing brew\033[0m"
  if [[ $(which brew) == "/usr/local/bin/brew" ]]
  then
      echo "Brew installed already, skipping"
  else
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  echo -e "\033[1m\033[34m==> Installing brew formulas\033[0m"
  brew bundle --file=~/.dotfiles/Brewfile
fi

# GIT
ln -sf ~/.dotfiles/git/gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/git/gitignore ~/.gitignore

# AG

# agignore = gitignore
ln -sf ~/.dotfiles/git/gitignore ~/.agignore

# ZSH

# install sorin-ionescu/prezto
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

ln -sf ~/.dotfiles/zsh/zlogin.zsh ~/.zlogin
ln -sf ~/.dotfiles/zsh/zlogout.zsh ~/.zlogout
ln -sf ~/.dotfiles/zsh/zpreztorc.zsh ~/.zpreztorc
ln -sf ~/.dotfiles/zsh/zprofile.zsh ~/.zprofile
ln -sf ~/.dotfiles/zsh/zshenv.zsh ~/.zshenv
ln -sf ~/.dotfiles/zsh/zshrc.zsh ~/.zshrc

# change shell to zsh
# echo $(which zsh) >> /etc/shells
# chsh -s $(which zsh)
sudo dscl . -create /Users/$USER UserShell $(which zsh)

# JAVASCRIPT

ln -sf ~/.dotfiles/javascript/editorconfig ~/.editorconfig
ln -sf ~/.dotfiles/javascript/prettierignore ~/.prettierignore
ln -sf ~/.dotfiles/javascript/eslintignore ~/.eslintignore
ln -sf ~/.dotfiles/javascript/eslintrc ~/.eslintrc
ln -sf ~/.dotfiles/javascript/prettierrc ~/.prettierrc

# install global JS dependencies
cd ~/.dotfiles/yarn/global && yarn

# TMUX

ln -sf ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -sf ~/.dotfiles/tmux/tmux.conf.local ~/.tmux.conf.local

# install tmux plugins
tmux start-server
tmux new-session -d
~/.dotfiles/tmux/plugins/tpm/scripts/install_plugins.sh
tmux kill-server

# HELM

# install helm plugins
helm plugin install https://github.com/databus23/helm-diff --version master


# ITERM2

# Specify the preferences directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.dotfiles/iterm"
# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
