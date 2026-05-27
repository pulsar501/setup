#!/usr/bin/env bash
set -euo pipefail

IMAGE="dotfiles-test"
LOCAL=false
SHELL_MODE=false
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/patrickpfenning/dotfiles.git}"

usage() {
  echo "Usage: $0 [--local] [--shell]"
  echo "  --local  bind-mount ~/.dotfiles instead of cloning from GitHub"
  echo "  --shell  drop into an interactive shell instead of running bats"
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --local) LOCAL=true ;;
    --shell) SHELL_MODE=true ;;
    *) usage ;;
  esac
  shift
done

echo "==> Building image"
docker build -t "$IMAGE" "$(dirname "$0")"

DOCKER_ARGS=(--rm -it)

if $LOCAL; then
  DOCKER_ARGS+=(-v "$HOME/.dotfiles:/home/p/.dotfiles:ro")
else
  DOCKER_ARGS+=(-e "DOTFILES_REPO=$DOTFILES_REPO")
fi

if $SHELL_MODE; then
  DOCKER_ARGS+=(--entrypoint bash)
  DOCKER_ARGS+=("$IMAGE")
else
  DOCKER_ARGS+=("$IMAGE" bats .dotfiles/tests/)
fi

echo "==> Running container"
docker run "${DOCKER_ARGS[@]}"
