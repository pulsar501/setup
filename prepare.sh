#!/bin/bash

set -e

echo "UPDATING SYSTEM"
sudo apt update -qqq && sudo apt -qqq -o Dpkg::Use-Pty=0 upgrade -y && sudo apt -qqq -o Dpkg::Use-Pty=0 dist-upgrade -y
sudo apt -qqq -o Dpkg::Use-Pty=0 install git software-properties-common python3-full python-is-python3 python3-pip -y

echo "INSTALL ANSIBLE"
sudo python3 -m pip install pipx --break-system-packages
sudo pipx ensurepath --global
pipx ensurepath
pipx --global install --include-deps ansible
