#!/bin/bash

# Check if Homebrew is installed, install if not
if ! command -v brew &>/dev/null; then
  echo "Homebrew not found, installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed."
fi

# Update Homebrew
echo "Updating Homebrew..."
brew update

# Add necessary taps if they are not already tapped
echo "Adding required taps..."
if ! brew tap | grep -q "koekeishiya/formulae"; then
  brew tap koekeishiya/formulae
fi
if ! brew tap | grep -q "shinokada/tera"; then
  brew tap shinokada/tera
fi

# Function to install a package if it's not already installed
install_package() {
  if ! brew list "$1" &>/dev/null; then
    echo "Installing $1..."
    brew install "$1"
  else
    echo "$1 is already installed, skipping."
  fi
}

# List of packages to install
packages=(
  aerospace
  brave-browser
  duti
  font-devicons
  font-hack-nerd-font
  font-menlo-for-powerline
  font-meslo-lg-nerd-font
  font-noto-color-emoji
  ghostty
  vlc
  appstream-glib
  bash
  cbonsai
  chafa
  choose-gui
  cmatrix
  coreutils
  ffmpeg
  fzf
  gh
  git
  htmlq
  mpv
  mpc
  mpd
  ncmpcpp
  wget
  yt-dlp
  irssi
  yabai
  lsd
  neovim
  pkgconf
  ranger
  ripgrep
  shinokada/tera/tera
  streamlink
  tmux
  zoxide
  zsh-navigation-tools
)

# Install each package
for package in "${packages[@]}"; do
  install_package "$package"
done

# Cleanup
echo "Cleaning up..."
brew cleanup

echo "Installation complete!"
