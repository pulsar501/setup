# Setup

## Repo setup
```shell
git config --local include.path .gitconfig
```

## setup new machine
```shell
git clone https://github.com/ppfenning92/setup.git
./setup/prepare.sh
ANSIBLE_EXECUTABLE=/bin/bash ansible-playbook setup/init.yml --ask-become-pass --ask-vault-pass -u $USER
```

## Test
```shell
docker run -it -v "$PWD:/home/$(whoami)/$(basename $PWD)" --rm setup-ubuntu
```
