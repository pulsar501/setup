#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/.dotfiles"
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/patrickpfenning/dotfiles.git}"

# Allow bind-mounting a local dotfiles checkout for testing
if [[ ! -d "$DOTFILES/.git" ]]; then
  echo "==> Cloning dotfiles"
  git clone --depth=1 "$DOTFILES_REPO" "$DOTFILES"
fi

# Mirror what the Ansible dirs role creates
echo "==> Creating runtime dirs"
mkdir -p \
  "$HOME/code" \
  "$XDG_CONFIG_HOME" \
  "$XDG_DATA_HOME" \
  "$XDG_CACHE_HOME" \
  "$XDG_STATE_HOME" \
  "$HOME/.local/bin" \
  "$XDG_STATE_HOME/zsh"

echo "==> Stowing dotfiles"
stow --dir="$DOTFILES" --target="$HOME" \
  --ignore='README.md' --ignore='docs' --ignore='.gitignore' \
  --ignore='.git' --ignore='.gitmodules' --ignore='dotfiles-gitconfig' \
  --ignore='.githooks' --ignore='.github' --ignore='.local/state' \
  --ignore='.DS_Store' --ignore='tests' --ignore='.envrc.example' \
  --ignore='.env.op.example' --ignore='mise.toml.example' \
  .

exec "$@"
