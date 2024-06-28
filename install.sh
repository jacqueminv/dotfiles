#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -eu

# Install Homebrew
command -v brew >/dev/null 2>&1 || \
  (echo '🍺  Installing Homebrew' && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)")

# Install Oh My Zsh
if [ ! -f ~/.oh-my-zsh/oh-my-zsh.sh ]; then
  (echo '💰  Installing oh-my-zsh' && yes | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)")
fi

if ! chezmoi="$(command -v chezmoi)"; then
	echo "Installing chezmoi" >&2
	brew install chezmoi
	(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

set -- init --apply jacqueminv 

echo "Running 'chezmoi $*'" >&2
# exec: replace current process with chezmoi
exec "$chezmoi" "$@"
