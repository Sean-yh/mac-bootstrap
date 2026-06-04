#!/usr/bin/env bash
set -euo pipefail

profile="${1:-minimal}"
repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$profile" in
  minimal)
    brewfile="$repo_dir/Brewfile.minimal"
    ;;
  dev)
    brewfile="$repo_dir/Brewfile.dev"
    ;;
  *)
    echo "Usage: ./install.sh [minimal|dev]"
    exit 2
    ;;
esac

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi

  echo "Homebrew is not installed."
  echo "Install it first from https://brew.sh, then rerun this script."
  exit 1
}

link_file() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
    mv "$target" "$backup"
    echo "Backed up $target to $backup"
  fi

  ln -sfn "$source" "$target"
}

install_npm_packages() {
  if ! command -v npm >/dev/null 2>&1; then
    echo "npm not found; skipping global npm packages."
    return
  fi

  while IFS= read -r package; do
    [ -z "$package" ] && continue
    npm install -g "$package"
  done < "$repo_dir/npm-packages.txt"
}

ensure_homebrew
brew bundle --file "$brewfile"

link_file "$repo_dir/dotfiles/zshrc" "$HOME/.zshrc"
link_file "$repo_dir/dotfiles/zprofile" "$HOME/.zprofile"
link_file "$repo_dir/dotfiles/gitconfig" "$HOME/.gitconfig"
mkdir -p "$HOME/.config"
link_file "$repo_dir/dotfiles/starship.toml" "$HOME/.config/starship.toml"

install_npm_packages

echo "Bootstrap complete. Run 'gh auth login' on this machine if GitHub is not authenticated."
