#!/bin/bash
set -e

OS="$(uname -s)"

if [[ "$OS" == "Darwin" ]]; then
  echo "==> macOS detected"

  if ! command -v brew >/dev/null 2>&1; then
    echo "==> Installing Homebrew"
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  echo "==> Installing Ansible via pipx"
  brew install pipx
  pipx ensurepath
  pipx install --include-deps ansible

elif [[ "$OS" == "Linux" ]]; then
  if command -v apt-get >/dev/null 2>&1; then
    echo "==> Debian/Ubuntu detected"
    sudo apt update -qqq
    sudo apt -qqq -o Dpkg::Use-Pty=0 upgrade -y
    sudo apt -qqq -o Dpkg::Use-Pty=0 install git software-properties-common python3-full python-is-python3 python3-pip -y

  elif command -v pacman >/dev/null 2>&1; then
    echo "==> Arch detected"
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm git python python-pip

  else
    echo "ERROR: unsupported Linux package manager" >&2
    exit 1
  fi

  echo "==> Installing Ansible via pipx"
  sudo python3 -m pip install pipx --break-system-packages
  sudo pipx ensurepath --global
  pipx ensurepath
  pipx --global install --include-deps ansible

else
  echo "ERROR: unsupported OS: $OS" >&2
  exit 1
fi

echo "==> Done. Run: ansible-playbook init.yml"
